{ buildVersion, sha256, dev ? false }:

{ fetchurl, stdenv, xorg, glib, gtk3, cairo, pango, libredirect, makeWrapper, wrapGAppsHook
, pkexecPath ? "/run/wrappers/bin/pkexec", gksuSupport ? false, gksu
, writeScript, common-updater-scripts, curl, gnugrep
}:

assert gksuSupport -> gksu != null;

let
  libPath = stdenv.lib.makeLibraryPath [ xorg.libX11 glib gtk3 cairo pango ];
  redirects = [ "/usr/bin/pkexec=${pkexecPath}" ]
    ++ stdenv.lib.optional gksuSupport "/usr/bin/gksudo=${gksu}/bin/gksudo";
in let
  # package with just the binaries
  sublime_merge = stdenv.mkDerivation {
    pname = "sublime-merge-bin";
    version = buildVersion;

    src = fetchurl {
      name = "sublime-merge-${buildVersion}.tar.xz";
      url = "https://download.sublimetext.com/sublime_merge_build_${buildVersion}_x64.tar.xz";
      inherit sha256;
    };

    dontStrip = true;
    dontPatchELF = true;
    buildInputs = [ glib gtk3 ]; # for GSETTINGS_SCHEMAS_PATH
    nativeBuildInputs = [ makeWrapper wrapGAppsHook ];

    buildPhase = ''
      runHook preBuild

      for binary in sublime_merge crash_reporter git-credential-sublime ssh-askpass-sublime; do
        patchelf \
          --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath ${libPath}:${stdenv.cc.cc.lib}/lib64 \
          $binary
      done

      # Rewrite pkexec|gksudo argument. Note that we can't delete bytes in binary.
      sed -i -e 's,/bin/cp\x00,cp\x00\x00\x00\x00\x00\x00,g' sublime_merge

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
      wrapProgram $out/sublime_merge \
        --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
        --set NIX_REDIRECTS ${builtins.concatStringsSep ":" redirects} \
        "''${gappsWrapperArgs[@]}"
    '';
  };
in stdenv.mkDerivation {
  pname = "sublime-merge";
  version = buildVersion;

  phases = [ "installPhase" ];

  inherit sublime_merge;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p "$out/bin"
    makeWrapper "$sublime_merge/sublime_merge" "$out/bin/sublime_merge"
    ln -s "$out/bin/sublime_merge" "$out/bin/smerge"
    mkdir -p "$out/share/applications"
    substitute "$sublime_merge/sublime_merge.desktop" "$out/share/applications/sublime_merge.desktop" --replace "/opt/sublime_merge/sublime_merge" "$out/bin/sublime_merge"
    for directory in $sublime_merge/Icon/*; do
      size=$(basename $directory)
      mkdir -p "$out/share/icons/hicolor/$size/apps"
      ln -s "$sublime_merge/Icon/$size/sublime-merge.png" "$out/share/icons/hicolor/$size/apps"
    done
  '';

  passthru.updateScript = writeScript "sublime-merge-update-script" ''
    #!${stdenv.shell}
    set -o errexit
    PATH=${stdenv.lib.makeBinPath [ common-updater-scripts curl gnugrep ]}

    latestVersion=$(curl -s https://www.sublimemerge.com/${if dev then "dev" else "download"} | grep -Po '(?<=<p class="latest"><i>Version:</i> Build )([0-9]+)')

    update-source-version sublime-merge${stdenv.lib.optionalString dev "-dev"}.sublime_merge $latestVersion --file=pkgs/applications/version-management/sublime-merge/default.nix --version-key=buildVersion --system=x86_64-linux
  '';

  meta = with stdenv.lib; {
    description = "Git client from the makers of Sublime Text";
    homepage = https://www.sublimemerge.com;
    maintainers = with maintainers; [ zookatron ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
