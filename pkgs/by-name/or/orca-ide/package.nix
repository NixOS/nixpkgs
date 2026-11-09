{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  gobject-introspection,
  versionCheckHook,
  wrapGAppsHook3,
  at-spi2-core,
  bashNonInteractive,
  coreutils,
  electron_43,
  gdk-pixbuf,
  glib,
  gtk3,
  pango,
  python3,
  wayland,
  xclip,
  xdg-utils,
  xdotool,
  xvfb,
}:

let
  # Each Electron major has breaking API changes, so update.sh keeps this at
  # the major upstream builds Orca with.
  electron = electron_43;

  # Computer use runs resources/computer-use-linux/runtime.py, which imports
  # the Atspi, Gdk, GdkX11 and GdkPixbuf typelibs through PyGObject.
  computerUsePython = python3.withPackages (ps: [ ps.pygobject3 ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "orca-ide";
  version = "1.4.255";

  src =
    let
      selectSystem =
        attrs:
        attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
      arch = selectSystem {
        x86_64-linux = "amd64";
        aarch64-linux = "arm64";
      };
    in
    fetchurl {
      url = "https://github.com/stablyai/orca/releases/download/v${finalAttrs.version}/orca-ide_${finalAttrs.version}_${arch}.deb";
      hash = selectSystem {
        x86_64-linux = "sha256-bfU/T2yRn9HxDf41EZQJNKzJQKd1TrGw6JbSxi5K3Vo=";
        aarch64-linux = "sha256-wE88O1yM+EQnA74Y/+4J+DW+hg3IfdkGHBpsyKqsYPA=";
      };
    };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    # Typelibs for the computer use script.
    at-spi2-core
    gdk-pixbuf
    glib
    gtk3
    pango
    # For patchShebangs on the CLI shim.
    bashNonInteractive
    # libstdc++ for the bundled native modules.
    stdenv.cc.cc.lib
  ];

  # The bundled Wayland clipboard helper loads these with dlopen().
  runtimeDependencies = [
    gtk3
    wayland
  ];

  # Fixup must leave two things unchanged: resources/orcad-template, the daemon
  # builds that Orca installs on SSH hosts after checking them against the
  # sha256 manifest in orcad-template.json, and the Electron copy, which is
  # already patched. postFixup patches the rest of resources.
  dontAutoPatchelf = true;
  dontPatchELF = true;
  dontPatchShebangs = true;
  dontStrip = true;
  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    # Electron sets process.resourcesPath and app.isPackaged from the path of
    # its binary, which Orca relies on throughout, so Orca runs a renamed copy
    # of nixpkgs' Electron instead of wrapping it.
    mkdir -p $out/lib
    cp -r ${electron.dist} $out/lib/orca-ide
    chmod -R u+w $out/lib/orca-ide
    mv $out/lib/orca-ide/electron $out/lib/orca-ide/orca-ide
    rm -r $out/lib/orca-ide/resources
    cp -r opt/Orca/resources $out/lib/orca-ide/resources
    cp -r usr/share $out/share

    # The app runs resources/agent-browser-linux-*, so postFixup patches it.
    # SSH deploys check it against the manifest too and look for it, and for
    # ripgrep, next to the template, so ORCA_ORCAD_TEMPLATE_PATH points them
    # at an unpatched copy here.
    mkdir -p $out/libexec/orca-ide/orcad
    cp opt/Orca/resources/agent-browser-linux-* $out/libexec/orca-ide/orcad/
    ln -s $out/lib/orca-ide/resources/{orcad-template,ripgrep} $out/libexec/orca-ide/orcad/

    substituteInPlace $out/share/applications/orca-ide.desktop \
      --replace-fail 'Exec=/opt/Orca/orca-ide' "Exec=$out/lib/orca-ide/orca-ide"

    runHook postInstall
  '';

  postFixup = ''
    autoPatchelf -- $(find $out/lib/orca-ide/resources -mindepth 1 -maxdepth 1 ! -name orcad-template)

    # The .deb's postinst links /usr/bin/orca-ide to this CLI shim, which
    # resolves its own path with dirname and readlink.
    patchShebangs $out/lib/orca-ide/resources/bin/orca-ide
    makeWrapper $out/lib/orca-ide/resources/bin/orca-ide $out/bin/orca-ide \
      --suffix PATH : ${lib.makeBinPath [ coreutils ]}

    # Orca runs the computer use script with whatever python3 is on PATH, so
    # point it at a script that re-executes runtime.py with PyGObject.
    makeWrapper ${lib.getExe computerUsePython} $out/libexec/orca-ide/computer-use \
      "''${gappsWrapperArgs[@]}" \
      --add-flags $out/lib/orca-ide/resources/computer-use-linux/runtime.py
    cat > $out/libexec/orca-ide/computer-use.py <<EOF
    import os
    import sys
    os.execv("$out/libexec/orca-ide/computer-use", ["computer-use", *sys.argv[1:]])
    EOF

    # Tools from the .deb's Depends that Orca runs: python3 for the computer use
    # script, Xvfb for headless `orca-ide serve`, xdotool and xclip for computer
    # use, and xdg-open for links. Orca also runs gdbus to find an unlocked
    # keyring on desktops Chromium does not recognise, such as Hyprland.
    #
    # orcad, the default runtime for `orca-ide serve`, looks for Orca's
    # Electron only at fixed paths such as /opt/Orca/orca-ide, so it would
    # serve without a browser here. Electron serve has its own.
    #
    # As in electron's wrapper: nixpkgs' Chromium finds its sandbox helper only
    # through CHROME_DEVEL_SANDBOX.
    wrapProgram $out/lib/orca-ide/orca-ide \
      "''${gappsWrapperArgs[@]}" \
      --set CHROME_DEVEL_SANDBOX $out/lib/orca-ide/chrome-sandbox \
      --suffix PATH : ${
        lib.makeBinPath [
          computerUsePython
          glib
          xclip
          xdg-utils
          xdotool
          xvfb
        ]
      } \
      --set-default ORCA_COMPUTER_DESKTOP_SCRIPT_PROVIDER_PATH $out/libexec/orca-ide/computer-use.py \
      --set-default ORCA_SERVE_RUNTIME electron \
      --set-default ORCA_ORCAD_TEMPLATE_PATH $out/libexec/orca-ide/orcad/orcad-template
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "IDE for running coding agents in parallel git worktrees";
    homepage = "https://onorca.dev";
    changelog = "https://github.com/stablyai/orca/releases/tag/v${finalAttrs.version}";
    # Orca is MIT; the bundled @anthropic-ai/claude-agent-sdk is proprietary.
    license = with lib.licenses; [
      mit
      unfree
    ];
    maintainers = with lib.maintainers; [
      imcvampire
      rohan879
    ];
    mainProgram = "orca-ide";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
