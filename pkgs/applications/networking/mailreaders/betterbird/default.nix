{ lib
, buildMozillaMach
, cacert
, fetchFromGitHub
, fetchurl
, git
, libdbusmenu-gtk3
, runtimeShell
, thunderbirdPackages
}:

let
  thunderbird-unwrapped = thunderbirdPackages.thunderbird-102;

  version = "102.14.0";
  majVer = lib.versions.major version;

  betterbird-patches = fetchFromGitHub {
    owner = "Betterbird";
    repo = "thunderbird-patches";
    rev = "${version}-bb39";
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
    hash = "sha256-O9nGlJs3OziQLbdbdt3eFRHvk1A9cdEsbKDtsZrnY5Q=";
  };
in ((buildMozillaMach {
  pname = "betterbird";
  inherit version;

  applicationName = "Betterbird";
  binaryName = "betterbird";
  inherit (thunderbird-unwrapped) application extraPatches;

  src = fetchurl {
    # https://download.cdn.mozilla.net/pub/thunderbird/releases/
    url = "mirror://mozilla/thunderbird/releases/${version}/source/thunderbird-${version}.source.tar.xz";
    sha512 = "4ae3f216833aec55421f827d55bc1b5fc2f0ad4fefecb27724a5be3318c351df24d30a4897b924e733ed2e3995be284b6d135049d46001143fb1c961fefc1830";
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
}).overrideAttrs (oldAttrs: {
  postInstall = oldAttrs.postInstall or "" + ''
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
