{ stdenv
, lib
, copyDesktopItems
, makeDesktopItem
, unzip
, libsecret
, libXScrnSaver
, libxshmfence
, buildPackages
, at-spi2-atk
, autoPatchelfHook
, alsa-lib
, mesa
, nss
, nspr
, xorg
, systemd
, fontconfig
, libdbusmenu
, glib
, buildFHSEnv
, wayland
, libglvnd
, libkrb5

  # Populate passthru.tests
, tests

  # needed to fix "Save as Root"
, asar
, bash

  # Attributes inherit from specific versions
, version
, src
, meta
, sourceRoot
, commandLineArgs
, executableName
, longName
, shortName
, pname
, updateScript
, dontFixup ? false
, rev ? null
, vscodeServer ? null
, sourceExecutableName ? executableName
, useVSCodeRipgrep ? false
, ripgrep
}:

stdenv.mkDerivation (finalAttrs:
let

  # Vscode and variants allow for users to download and use extensions
  # which often include the usage of pre-built binaries.
  # This has been an on-going painpoint for many users, as
  # a full extension update cycle has to be done through nixpkgs
  # in order to create or update extensions.
  # See: #83288 #91179 #73810 #41189
  #
  # buildFHSEnv allows for users to use the existing vscode
  # extension tooling without significant pain.
  fhs = { additionalPkgs ? pkgs: [ ] }: buildFHSEnv {
    # also determines the name of the wrapped command
    name = executableName;

    # additional libraries which are commonly needed for extensions
    targetPkgs = pkgs: (with pkgs; [
      # ld-linux-x86-64-linux.so.2 and others
      glibc

      # dotnet
      curl
      icu
      libunwind
      libuuid
      lttng-ust
      openssl
      zlib

      # mono
      krb5
    ]) ++ additionalPkgs pkgs;

    extraBwrapArgs = [
      "--bind-try /etc/nixos/ /etc/nixos/"
    ];

    # symlink shared assets, including icons and desktop entries
    extraInstallCommands = ''
      ln -s "${finalAttrs.finalPackage}/share" "$out/"
    '';

    runScript = "${finalAttrs.finalPackage}/bin/${executableName}";

    # vscode likes to kill the parent so that the
    # gui application isn't attached to the terminal session
    dieWithParent = false;

    passthru = {
      inherit executableName;
      inherit (finalAttrs.finalPackage) pname version; # for home-manager module
    };

    meta = meta // {
      description = ''
        Wrapped variant of ${pname} which launches in a FHS compatible environment.
        Should allow for easy usage of extensions without nix-specific modifications.
      '';
    };
  };
in
{

  inherit pname version src sourceRoot dontFixup;

  passthru = {
    inherit executableName longName tests updateScript;
    fhs = fhs { };
    fhsWithPackages = f: fhs { additionalPkgs = f; };
  } // lib.optionalAttrs (vscodeServer != null) {
    inherit rev vscodeServer;
  };

  desktopItems = [
    (makeDesktopItem {
      name = executableName;
      desktopName = longName;
      comment = "Code Editing. Redefined.";
      genericName = "Text Editor";
      exec = "${executableName} %F";
      icon = "vs${executableName}";
      startupNotify = true;
      startupWMClass = shortName;
      categories = [ "Utility" "TextEditor" "Development" "IDE" ];
      keywords = [ "vscode" ];
      actions.new-empty-window = {
        name = "New Empty Window";
        exec = "${executableName} --new-window %F";
        icon = "vs${executableName}";
      };
    })
    (makeDesktopItem {
      name = executableName + "-url-handler";
      desktopName = longName + " - URL Handler";
      comment = "Code Editing. Redefined.";
      genericName = "Text Editor";
      exec = executableName + " --open-url %U";
      icon = "vs${executableName}";
      startupNotify = true;
      categories = [ "Utility" "TextEditor" "Development" "IDE" ];
      mimeTypes = [ "x-scheme-handler/vs${executableName}" ];
      keywords = [ "vscode" ];
      noDisplay = true;
    })
  ];

  buildInputs = [ libsecret libXScrnSaver libxshmfence ]
    ++ lib.optionals (!stdenv.isDarwin) [ alsa-lib at-spi2-atk libkrb5 mesa nss nspr systemd xorg.libxkbfile ];

  runtimeDependencies = lib.optionals stdenv.isLinux [ (lib.getLib systemd) fontconfig.lib libdbusmenu wayland libsecret ];

  nativeBuildInputs = [ unzip ]
    ++ lib.optionals stdenv.isLinux [
    autoPatchelfHook
    asar
    copyDesktopItems
    # override doesn't preserve splicing https://github.com/NixOS/nixpkgs/issues/132651
    (buildPackages.wrapGAppsHook3.override { inherit (buildPackages) makeWrapper; })
  ];

  dontBuild = true;
  dontConfigure = true;
  noDumpEnvVars = true;

  installPhase = ''
    runHook preInstall
  '' + (if stdenv.isDarwin then ''
    mkdir -p "$out/Applications/${longName}.app" "$out/bin"
    cp -r ./* "$out/Applications/${longName}.app"
    ln -s "$out/Applications/${longName}.app/Contents/Resources/app/bin/${sourceExecutableName}" "$out/bin/${executableName}"
  '' else ''
    mkdir -p "$out/lib/vscode" "$out/bin"
    cp -r ./* "$out/lib/vscode"

    ln -s "$out/lib/vscode/bin/${sourceExecutableName}" "$out/bin/${executableName}"

    # These are named vscode.png, vscode-insiders.png, etc to match the name in upstream *.deb packages.
    mkdir -p "$out/share/pixmaps"
    cp "$out/lib/vscode/resources/app/resources/linux/code.png" "$out/share/pixmaps/vs${executableName}.png"

    # Override the previously determined VSCODE_PATH with the one we know to be correct
    sed -i "/ELECTRON=/iVSCODE_PATH='$out/lib/vscode'" "$out/bin/${executableName}"
    grep -q "VSCODE_PATH='$out/lib/vscode'" "$out/bin/${executableName}" # check if sed succeeded

    # Remove native encryption code, as it derives the key from the executable path which does not work for us.
    # The credentials should be stored in a secure keychain already, so the benefit of this is questionable
    # in the first place.
    rm -rf $out/lib/vscode/resources/app/node_modules/vscode-encrypt
  '') + ''
    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
        ${ # we cannot use runtimeDependencies otherwise libdbusmenu do not work on kde
          lib.optionalString stdenv.isLinux
          "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libdbusmenu ]}"}
      # Add gio to PATH so that moving files to the trash works when not using a desktop environment
      --prefix PATH : ${glib.bin}/bin
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
      --add-flags ${lib.escapeShellArg commandLineArgs}
    )
  '';

  # See https://github.com/NixOS/nixpkgs/issues/49643#issuecomment-873853897
  # linux only because of https://github.com/NixOS/nixpkgs/issues/138729
  postPatch = lib.optionalString stdenv.isLinux ''
    # this is a fix for "save as root" functionality
    packed="resources/app/node_modules.asar"
    unpacked="resources/app/node_modules"
    asar extract "$packed" "$unpacked"
    substituteInPlace $unpacked/@vscode/sudo-prompt/index.js \
      --replace "/usr/bin/pkexec" "/run/wrappers/bin/pkexec" \
      --replace "/bin/bash" "${bash}/bin/bash"
    rm -rf "$packed"

    # without this symlink loading JsChardet, the library that is used for auto encoding detection when files.autoGuessEncoding is true,
    # fails to load with: electron/js2c/renderer_init: Error: Cannot find module 'jschardet'
    # and the window immediately closes which renders VSCode unusable
    # see https://github.com/NixOS/nixpkgs/issues/152939 for full log
    ln -rs "$unpacked" "$packed"
  '' + (
    let
      vscodeRipgrep =
        if stdenv.isDarwin then
          "Contents/Resources/app/node_modules.asar.unpacked/@vscode/ripgrep/bin/rg"
        else
          "resources/app/node_modules/@vscode/ripgrep/bin/rg";
    in
    if !useVSCodeRipgrep then ''
      rm ${vscodeRipgrep}
      ln -s ${ripgrep}/bin/rg ${vscodeRipgrep}
    '' else ''
      chmod +x ${vscodeRipgrep}
    ''
  );

  postFixup = lib.optionalString stdenv.isLinux ''
    patchelf \
      --add-needed ${libglvnd}/lib/libGLESv2.so.2 \
      --add-needed ${libglvnd}/lib/libGL.so.1 \
      --add-needed ${libglvnd}/lib/libEGL.so.1 \
      $out/lib/vscode/${executableName}
  '';

  inherit meta;
})
