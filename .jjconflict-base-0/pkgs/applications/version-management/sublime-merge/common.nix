{
  buildVersion,
  dev ? false,
  aarch64sha256,
  x64sha256,
}:

{
  fetchurl,
  lib,
  stdenv,
  xorg,
  glib,
  libGL,
  glibcLocales,
  gtk3,
  cairo,
  pango,
  libredirect,
  makeWrapper,
  wrapGAppsHook3,
  pkexecPath ? "/run/wrappers/bin/pkexec",
  writeShellScript,
  common-updater-scripts,
  curl,
  gnugrep,
  coreutils,
}:

let
  pnameBase = "sublime-merge";
  packageAttribute = "sublime-merge${lib.optionalString dev "-dev"}";
  binaries = [
    "sublime_merge"
    crashHandlerBinary
    "git-credential-sublime"
    "ssh-askpass-sublime"
  ];
  primaryBinary = "sublime_merge";
  primaryBinaryAliases = [
    "smerge"
  ];
  crashHandlerBinary =
    if lib.versionAtLeast buildVersion "2086" then "crash_handler" else "crash_reporter";
  downloadUrl =
    arch: "https://download.sublimetext.com/sublime_merge_build_${buildVersion}_${arch}.tar.xz";
  versionUrl = "https://www.sublimemerge.com/${if dev then "dev" else "download"}";
  versionFile = builtins.toString ./default.nix;

  neededLibraries = [
    xorg.libX11
    glib
    gtk3
    cairo
    pango
    curl
  ];

  redirects = [
    "/usr/bin/pkexec=${pkexecPath}"
    "/bin/true=${coreutils}/bin/true"
  ];

  binaryPackage = stdenv.mkDerivation rec {
    pname = "${pnameBase}-bin";
    version = buildVersion;

    src = passthru.sources.${stdenv.hostPlatform.system};

    dontStrip = true;
    dontPatchELF = true;
    buildInputs = [
      glib
      # for GSETTINGS_SCHEMAS_PATH
      gtk3
    ];
    nativeBuildInputs = [
      makeWrapper
      wrapGAppsHook3
    ];

    buildPhase = ''
      runHook preBuild

      for binary in ${builtins.concatStringsSep " " binaries}; do
        patchelf \
          --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath ${lib.makeLibraryPath neededLibraries}:${libGL}/lib:${lib.getLib stdenv.cc.cc}/lib${lib.optionalString stdenv.hostPlatform.is64bit "64"} \
          $binary
      done

      # Rewrite pkexec argument. Note that we cannot delete bytes in binary.
      sed -i -e 's,/bin/cp\x00,cp\x00\x00\x00\x00\x00\x00,g' ${primaryBinary}

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r * $out/

      runHook postInstall
    '';

    dontWrapGApps = true; # non-standard location, need to wrap the executables manually

    postFixup = ''
      wrapProgram $out/${primaryBinary} \
        --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
        --set NIX_REDIRECTS ${builtins.concatStringsSep ":" redirects} \
        --set LOCALE_ARCHIVE "${glibcLocales.out}/lib/locale/locale-archive" \
        "''${gappsWrapperArgs[@]}"

      # We need to replace the ssh-askpass-sublime executable because the default one
      # will not function properly, in order to work it needs to pass an argv[0] to
      # the sublime_merge binary, and the built-in version will try to call the
      # sublime_merge wrapper script which cannot pass through the original argv[0] to
      # the sublime_merge binary. Thankfully the ssh-askpass-sublime functionality is
      # very simple and can be replaced with a simple wrapper script.
      rm $out/ssh-askpass-sublime
      makeWrapper $out/.${primaryBinary}-wrapped $out/ssh-askpass-sublime \
        --argv0 "/ssh-askpass-sublime"
    '';

    passthru = {
      sources = {
        "aarch64-linux" = fetchurl {
          url = downloadUrl "arm64";
          sha256 = aarch64sha256;
        };
        "x86_64-linux" = fetchurl {
          url = downloadUrl "x64";
          sha256 = x64sha256;
        };
      };
    };
  };
in
stdenv.mkDerivation (rec {
  pname = pnameBase;
  version = buildVersion;

  dontUnpack = true;

  ${primaryBinary} = binaryPackage;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase =
    ''
      runHook preInstall
      mkdir -p "$out/bin"
      makeWrapper "''$${primaryBinary}/${primaryBinary}" "$out/bin/${primaryBinary}"
    ''
    + builtins.concatStringsSep "" (
      map (binaryAlias: "ln -s $out/bin/${primaryBinary} $out/bin/${binaryAlias}\n") primaryBinaryAliases
    )
    + ''
      mkdir -p "$out/share/applications"

      substitute \
        "''$${primaryBinary}/${primaryBinary}.desktop" \
        "$out/share/applications/${primaryBinary}.desktop" \
        --replace-fail "/opt/${primaryBinary}/${primaryBinary}" "${primaryBinary}"

      for directory in ''$${primaryBinary}/Icon/*; do
        size=$(basename $directory)
        mkdir -p "$out/share/icons/hicolor/$size/apps"
        ln -s ''$${primaryBinary}/Icon/$size/* $out/share/icons/hicolor/$size/apps
      done
      runHook postInstall
    '';

  passthru = {
    updateScript =
      let
        script = writeShellScript "${packageAttribute}-update-script" ''
          set -o errexit
          PATH=${
            lib.makeBinPath [
              common-updater-scripts
              curl
              gnugrep
            ]
          }

          versionFile=$1
          latestVersion=$(curl -s ${versionUrl} | grep -Po '(?<=<p class="latest"><i>Version:</i> Build )([0-9]+)')

          if [[ "${buildVersion}" = "$latestVersion" ]]; then
              echo "The new version same as the old version."
              exit 0
          fi

          for platform in ${lib.escapeShellArgs meta.platforms}; do
              update-source-version "${packageAttribute}.${primaryBinary}" "$latestVersion" --ignore-same-version --file="$versionFile" --version-key=buildVersion --source-key="sources.$platform"
          done
        '';
      in
      [
        script
        versionFile
      ];
  };

  meta = {
    description = "Git client from the makers of Sublime Text";
    homepage = "https://www.sublimemerge.com";
    mainProgram = "sublime_merge";
    maintainers = with lib.maintainers; [ zookatron ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
})
