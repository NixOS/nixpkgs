{ buildVersion, sha256, dev ? false }:

{ fetchurl, lib, stdenv, xorg, glib, libGL, glibcLocales, gtk3, cairo, pango, libredirect, makeWrapper, wrapGAppsHook
, pkexecPath ? "/run/wrappers/bin/pkexec"
, writeScript, common-updater-scripts, curl, gnugrep, coreutils
}:

let
  pname = "sublime-merge";
  packageAttribute = "sublime-merge${lib.optionalString dev "-dev"}";
  binaries = [ "sublime_merge" "crash_reporter" "git-credential-sublime" "ssh-askpass-sublime" ];
  primaryBinary = "sublime_merge";
  primaryBinaryAliases = [ "smerge" ];
  downloadUrl = "https://download.sublimetext.com/sublime_merge_build_${buildVersion}_${arch}.tar.xz";
  versionUrl = "https://www.sublimemerge.com/${if dev then "dev" else "download"}";
  versionFile = builtins.toString ./default.nix;
  archSha256 = sha256;
  arch = "x64";

  libPath = lib.makeLibraryPath [ xorg.libX11 glib gtk3 cairo pango curl ];
  redirects = [ "/usr/bin/pkexec=${pkexecPath}" "/bin/true=${coreutils}/bin/true" ];
in let
  binaryPackage = stdenv.mkDerivation {
    pname = "${pname}-bin";
    version = buildVersion;

    src = fetchurl {
      url = downloadUrl;
      sha256 = archSha256;
    };

    dontStrip = true;
    dontPatchELF = true;
    buildInputs = [ glib gtk3 ]; # for GSETTINGS_SCHEMAS_PATH
    nativeBuildInputs = [ makeWrapper wrapGAppsHook ];

    buildPhase = ''
      runHook preBuild

      for binary in ${ builtins.concatStringsSep " " binaries }; do
        patchelf \
          --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath ${libPath}:${libGL}/lib:${stdenv.cc.cc.lib}/lib${lib.optionalString stdenv.is64bit "64"} \
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
      # the sublime_merge binary, and the built-in version will will try to call the
      # sublime_merge wrapper script which cannot pass through the original argv[0] to
      # the sublime_merge binary. Thankfully the ssh-askpass-sublime functionality is
      # very simple and can be replaced with a simple wrapper script.
      rm $out/ssh-askpass-sublime
      makeWrapper $out/.${primaryBinary}-wrapped $out/ssh-askpass-sublime \
        --argv0 "/ssh-askpass-sublime"
    '';
  };
in stdenv.mkDerivation (rec {
  inherit pname;
  version = buildVersion;

  dontUnpack = true;

  ${primaryBinary} = binaryPackage;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p "$out/bin"
    makeWrapper "''$${primaryBinary}/${primaryBinary}" "$out/bin/${primaryBinary}"
  '' + builtins.concatStringsSep "" (map (binaryAlias: "ln -s $out/bin/${primaryBinary} $out/bin/${binaryAlias}\n") primaryBinaryAliases) + ''
    mkdir -p "$out/share/applications"
    substitute "''$${primaryBinary}/${primaryBinary}.desktop" "$out/share/applications/${primaryBinary}.desktop" --replace "/opt/${primaryBinary}/${primaryBinary}" "$out/bin/${primaryBinary}"
    for directory in ''$${primaryBinary}/Icon/*; do
      size=$(basename $directory)
      mkdir -p "$out/share/icons/hicolor/$size/apps"
      ln -s ''$${primaryBinary}/Icon/$size/* $out/share/icons/hicolor/$size/apps
    done
  '';

  passthru.updateScript = writeScript "${pname}-update-script" ''
    #!${stdenv.shell}
    set -o errexit
    PATH=${lib.makeBinPath [ common-updater-scripts curl gnugrep ]}

    latestVersion=$(curl -s ${versionUrl} | grep -Po '(?<=<p class="latest"><i>Version:</i> Build )([0-9]+)')

    for platform in ${lib.concatStringsSep " " meta.platforms}; do
        # The script will not perform an update when the version attribute is up to date from previous platform run
        # We need to clear it before each run
        update-source-version ${packageAttribute}.${primaryBinary} 0 0000000000000000000000000000000000000000000000000000000000000000 --file=${versionFile} --version-key=buildVersion --system=$platform
        update-source-version ${packageAttribute}.${primaryBinary} $latestVersion --file=${versionFile} --version-key=buildVersion --system=$platform
    done
  '';

  meta = with lib; {
    description = "Git client from the makers of Sublime Text";
    homepage = "https://www.sublimemerge.com";
    maintainers = with maintainers; [ zookatron ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
})
