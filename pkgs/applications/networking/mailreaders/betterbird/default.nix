{
  lib,
  buildMozillaMach,
  cacert,
  fetchFromGitHub,
  fetchurl,
  git,
  libdbusmenu-gtk3,
  runtimeShell,
  thunderbirdPackages,
}:

let
  thunderbird-unwrapped = thunderbirdPackages.thunderbird-115;

  version = "115.9.0";
  majVer = lib.versions.major version;

  betterbird-patches = fetchFromGitHub {
    owner = "Betterbird";
    repo = "thunderbird-patches";
    rev = "${version}-bb26-build2";
    postFetch = ''
      echo "Retrieving external patches"

      echo "#!${runtimeShell}" > external.sh
      # if no external patches need to be downloaded, don't fail
      { grep " # " $out/${majVer}/series-M-C || true ; } >> external.sh
      { grep " # " $out/${majVer}/series || true ; } >> external.sh
      sed -i -e '/^#/d' external.sh
      sed -i -e 's/\/rev\//\/raw-rev\//' external.sh
      sed -i -e 's|\(.*\) # \(.*\)|curl \2 -o $out/${majVer}/external/\1|' external.sh
      chmod 700 external.sh

      mkdir $out/${majVer}/external
      SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
      . ./external.sh
      rm external.sh
    '';
    hash = "sha256-0RlI30zxiueeXdLEXPZevc8QyKr667juHk0bTcqBB1w=";
  };
in
(
  (buildMozillaMach {
    pname = "betterbird";
    inherit version;

    applicationName = "Betterbird";
    binaryName = "betterbird";
    branding = "comm/mail/branding/betterbird";
    inherit (thunderbird-unwrapped) application extraPatches;

    src = fetchurl {
      # https://download.cdn.mozilla.net/pub/thunderbird/releases/
      url = "mirror://mozilla/thunderbird/releases/${version}/source/thunderbird-${version}.source.tar.xz";
      hash = "sha256-Kut3ynA43289MG+cPSpOphWvDtzw9ykCFcpfMMEpDlc=";
    };

    extraPostPatch =
      thunderbird-unwrapped.extraPostPatch or ""
      # bash
      + ''
        PATH=$PATH:${lib.makeBinPath [ git ]}
        patches=$(mktemp -d)
        for dir in branding bugs external features misc; do
          cp -r ${betterbird-patches}/${majVer}/$dir/*.patch $patches/
        done
        cp ${betterbird-patches}/${majVer}/series* $patches/
        chmod -R +w $patches

        cd $patches
        # fix FHS paths to libdbusmenu
        substituteInPlace 12-feature-linux-systray.patch \
          --replace-fail "/usr/include/libdbusmenu-glib-0.4/" "${lib.getDev libdbusmenu-gtk3}/include/libdbusmenu-glib-0.4/" \
          --replace-fail "/usr/include/libdbusmenu-gtk3-0.4/" "${lib.getDev libdbusmenu-gtk3}/include/libdbusmenu-gtk3-0.4/"
        cd -

        chmod -R +w dom/base/test/gtest/

        while read patch; do
          patch="''${patch%%#*}"
          patch="''${patch% }"
          if [[ $patch == "" ]]; then
            continue
          fi

          # requires vendored icu, fails to link with our icu
          if [[ $patch == 14-feature-regexp-searchterm.patch || $patch == 14-feature-regexp-searchterm-m-c.patch ]]; then
            continue
          fi

          echo Applying patch $patch.
          if [[ $patch == *-m-c.patch ]]; then
            git apply -p1 -v < $patches/$patch
          else
            cd comm
            git apply -p1 -v < $patches/$patch
            cd ..
          fi
        done < <(cat $patches/series $patches/series-M-C)
      '';

    extraBuildInputs = [
      libdbusmenu-gtk3
    ];

    meta = with lib; {
      description = "Betterbird is a fine-tuned version of Mozilla Thunderbird, Thunderbird on steroids, if you will";
      homepage = "https://www.betterbird.eu/";
      mainProgram = "betterbird";
      maintainers = with maintainers; [ SuperSandro2000 ];
      inherit (thunderbird-unwrapped.meta)
        platforms
        badPlatforms
        broken
        license
        ;
      knownVulnerabilities = [ "CVE-2024-4367" ];
    };
  }).override
  {
    crashreporterSupport = false; # not supported
    geolocationSupport = false;
    webrtcSupport = false;

    pgoSupport = false; # console.warn: feeds: "downloadFeed: network connection unavailable"
  }
).overrideAttrs
  (oldAttrs: {
    postInstall =
      oldAttrs.postInstall or ""
      + ''
        mv $out/lib/thunderbird/* $out/lib/betterbird
        rmdir $out/lib/thunderbird/
        rm $out/bin/thunderbird
        ln -srf $out/lib/betterbird/betterbird $out/bin/betterbird
      '';

    doInstallCheck = false;

    passthru = oldAttrs.passthru // {
      inherit betterbird-patches;
    };
  })
