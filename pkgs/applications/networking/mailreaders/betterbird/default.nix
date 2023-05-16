{ lib
, buildMozillaMach
, cacert
, fetchFromGitHub
, fetchurl
, git
, libdbusmenu-gtk3
, runtimeShell
<<<<<<< HEAD
, thunderbirdPackages
}:

let
  thunderbird-unwrapped = thunderbirdPackages.thunderbird-102;

  version = "102.15.0";
  majVer = lib.versions.major version;

  betterbird-patches = fetchFromGitHub {
    owner = "Betterbird";
    repo = "thunderbird-patches";
    rev = "${version}-bb40";
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
    hash = "sha256-7/JEcP76rp0hSSxzlIlHqkcxTSEJQswFhCoOLYntQ5I=";
  };
in ((buildMozillaMach {
  pname = "betterbird";
  inherit version;
=======
, thunderbird-unwrapped
}:

((buildMozillaMach rec {
  pname = "betterbird";
  version = "102.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  applicationName = "Betterbird";
  binaryName = "betterbird";
  inherit (thunderbird-unwrapped) application extraPatches;

  src = fetchurl {
<<<<<<< HEAD
    # https://download.cdn.mozilla.net/pub/thunderbird/releases/
    url = "mirror://mozilla/thunderbird/releases/${version}/source/thunderbird-${version}.source.tar.xz";
    sha512 = "11d4c77049c532753c9b693d69ab9a0bcd0eb13d49f87a511ad8ba680b70041ac6f64c5f9cd5dd44246d46e7695d9bd51146b1fe62b0b7c9fbc862eb53d5cfda";
  };

  extraPostPatch = thunderbird-unwrapped.extraPostPatch or "" + /* bash */ ''
    PATH=$PATH:${lib.makeBinPath [ git ]}
    patches=$(mktemp -d)
    for dir in branding bugs external features misc; do
      cp -r ${betterbird-patches}/${majVer}/$dir/*.patch $patches/
      # files is not in series file and duplicated with external patch
      [[ $dir == bugs ]] && rm $patches/1820504-optimise-grapheme-m-c.patch
    done
    cp ${betterbird-patches}/${majVer}/series* $patches/
    chmod -R +w $patches

    cd $patches
    # fix FHS paths to libdbusmenu
=======
    # https://download.cdn.mozilla.net/pub/mozilla.org/thunderbird/releases/
    url = "mirror://mozilla/thunderbird/releases/${version}/source/thunderbird-${version}.source.tar.xz";
    sha512 = "2431eb8799184b261609c96bed3c9368bec9035a831aa5f744fa89e48aedb130385b268dd90f03bbddfec449dc3e5fad1b5f8727fe9e11e1d1f123a81b97ddf8";
  };

  extraPostPatch = let
    majVer = lib.versions.major version;
    betterbird = fetchFromGitHub {
      owner = "Betterbird";
      repo = "thunderbird-patches";
      rev = "${version}-bb30";
      postFetch = ''
        echo "Retrieving external patches"

        echo "#!${runtimeShell}" > external.sh
        grep " # " $out/${majVer}/series-M-C >> external.sh
        grep " # " $out/${majVer}/series >> external.sh
        sed -i -e 's/\/rev\//\/raw-rev\//' external.sh
        sed -i -e 's|\(.*\) # \(.*\)|curl \2 -o $out/${majVer}/external/\1|' external.sh
        chmod 700 external.sh

        mkdir $out/${majVer}/external
        SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
        . ./external.sh
        rm external.sh
      '';
      sha256 = "sha256-ouJSFz/5shNR9puVjrZRJq90DHTeSx7hAnDpuhkBsDo=";
    };
  in thunderbird-unwrapped.extraPostPatch or "" + /* bash */ ''
    PATH=$PATH:${lib.makeBinPath [ git ]}
    patches=$(mktemp -d)
    for dir in branding bugs external features misc; do
      cp -r ${betterbird}/${majVer}/$dir/*.patch $patches/
    done
    cp ${betterbird}/${majVer}/series* $patches/
    chmod -R +w $patches

    cd $patches
    patch -p1 < ${./betterbird.diff}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    substituteInPlace 12-feature-linux-systray.patch \
      --replace "/usr/include/libdbusmenu-glib-0.4/" "${lib.getDev libdbusmenu-gtk3}/include/libdbusmenu-glib-0.4/" \
      --replace "/usr/include/libdbusmenu-gtk3-0.4/" "${lib.getDev libdbusmenu-gtk3}/include/libdbusmenu-gtk3-0.4/"
    cd -

    chmod -R +w dom/base/test/gtest/

    while read patch; do
      patch="''${patch%%#*}"
      patch="''${patch% }"
      if [[ $patch == "" ]]; then
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

  extraConfigureFlags = [
    "--enable-application=comm/mail"
    "--with-branding=comm/mail/branding/betterbird"
  ];

  meta = with lib; {
    description = "Betterbird is a fine-tuned version of Mozilla Thunderbird, Thunderbird on steroids, if you will";
    homepage = "https://www.betterbird.eu/";
<<<<<<< HEAD
    mainProgram = "betterbird";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ SuperSandro2000 ];
    inherit (thunderbird-unwrapped.meta) platforms badPlatforms broken license;
  };
}).override {
  crashreporterSupport = false; # not supported
  geolocationSupport = false;
  webrtcSupport = false;

  pgoSupport = false; # console.warn: feeds: "downloadFeed: network connection unavailable"
<<<<<<< HEAD
}).overrideAttrs (oldAttrs: {
=======
}).overrideAttrs(oldAttrs: {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postInstall = oldAttrs.postInstall or "" + ''
    mv $out/lib/thunderbird/* $out/lib/betterbird
    rmdir $out/lib/thunderbird/
    rm $out/bin/thunderbird
    ln -srf $out/lib/betterbird/betterbird $out/bin/betterbird
  '';

  doInstallCheck = false;
<<<<<<< HEAD

  passthru = oldAttrs.passthru // {
    inherit betterbird-patches;
  };
=======
  requiredSystemFeatures = [];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
})
