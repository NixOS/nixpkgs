{ buildVersion, sha256, dev ? false }:

{ fetchurl, stdenv, xorg, glib, glibcLocales, gtk2, gtk3, cairo, pango, libredirect, makeWrapper, wrapGAppsHook
, pkexecPath ? "/run/wrappers/bin/pkexec", gksuSupport ? false, gksu
, writeScript, common-updater-scripts, curl, gnugrep
}:

assert gksuSupport -> gksu != null;

let
  pname = "sublime-merge";
  packageAttribute = "sublime-merge${stdenv.lib.optionalString dev "-dev"}";
  binaries = [ "sublime_merge" "crash_reporter" "git-credential-sublime" "ssh-askpass-sublime" ];
  primaryBinary = "sublime_merge";
  primaryBinaryAliases = [ "smerge" ];
  downloadUrl = "https://download.sublimetext.com/sublime_merge_build_${buildVersion}_${arch}.tar.xz";
  downloadArchiveType = "tar.xz";
  versionUrl = "https://www.sublimemerge.com/${if dev then "dev" else "download"}";
  versionFile = "pkgs/applications/version-management/sublime-merge/default.nix";
  usesGtk2 = false;
  archSha256 = sha256;
  arch = "x64";

  libPath = stdenv.lib.makeLibraryPath [ xorg.libX11 glib (if usesGtk2 then gtk2 else gtk3) cairo pango ];
  redirects = [ "/usr/bin/pkexec=${pkexecPath}" ]
    ++ stdenv.lib.optional gksuSupport "/usr/bin/gksudo=${gksu}/bin/gksudo";
in let
  binaryPackage = stdenv.mkDerivation {
    pname = "${pname}-bin";
    version = buildVersion;

    src = fetchurl {
      name = "${pname}-bin-${buildVersion}.${downloadArchiveType}";
      url = downloadUrl;
      sha256 = archSha256;
    };

    dontStrip = true;
    dontPatchELF = true;
    buildInputs = stdenv.lib.optionals (!usesGtk2) [ glib gtk3 ]; # for GSETTINGS_SCHEMAS_PATH
    nativeBuildInputs = [ makeWrapper ] ++ stdenv.lib.optional (!usesGtk2) wrapGAppsHook;

    buildPhase = ''
      runHook preBuild

      for binary in ${ builtins.concatStringsSep " " binaries }; do
        patchelf \
          --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath ${libPath}:${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"} \
          $binary
      done

      # Rewrite pkexec|gksudo argument. Note that we can't delete bytes in binary.
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
        ${stdenv.lib.optionalString (!usesGtk2) ''"''${gappsWrapperArgs[@]}"''}
    '';
  };
in stdenv.mkDerivation (rec {
  inherit pname;
  version = buildVersion;

  phases = [ "installPhase" ];

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
    PATH=${stdenv.lib.makeBinPath [ common-updater-scripts curl gnugrep ]}

    latestVersion=$(curl -s ${versionUrl} | grep -Po '(?<=<p class="latest"><i>Version:</i> Build )([0-9]+)')

    for platform in ${stdenv.lib.concatStringsSep " " meta.platforms}; do
        # The script will not perform an update when the version attribute is up to date from previous platform run
        # We need to clear it before each run
        update-source-version ${packageAttribute}.${primaryBinary} 0 0000000000000000000000000000000000000000000000000000000000000000 --file=${versionFile} --version-key=buildVersion --system=$platform
        update-source-version ${packageAttribute}.${primaryBinary} $latestVersion --file=${versionFile} --version-key=buildVersion --system=$platform
    done
  '';

  meta = with stdenv.lib; {
    description = "Git client from the makers of Sublime Text";
    homepage = https://www.sublimemerge.com;
    maintainers = with maintainers; [ zookatron ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
})
