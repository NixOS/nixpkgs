{ lib
, buildMozillaMach
, cacert
, fetchFromGitHub
, fetchurl
, git
, libdbusmenu-gtk3
, runtimeShell
, thunderbird-unwrapped
}:

((buildMozillaMach rec {
  pname = "betterbird";
  version = "102.8.0";

  applicationName = "Betterbird";
  binaryName = "betterbird";
  inherit (thunderbird-unwrapped) application extraPatches;

  src = fetchurl {
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
    maintainers = with maintainers; [ SuperSandro2000 ];
    inherit (thunderbird-unwrapped.meta) platforms badPlatforms broken license;
  };
}).override {
  crashreporterSupport = false; # not supported
  geolocationSupport = false;
  webrtcSupport = false;

  pgoSupport = false; # console.warn: feeds: "downloadFeed: network connection unavailable"
}).overrideAttrs(oldAttrs: {
  postInstall = oldAttrs.postInstall or "" + ''
    mv $out/lib/thunderbird/* $out/lib/betterbird
    rmdir $out/lib/thunderbird/
    rm $out/bin/thunderbird
    ln -srf $out/lib/betterbird/betterbird $out/bin/betterbird
  '';

  doInstallCheck = false;
  requiredSystemFeatures = [];
})
