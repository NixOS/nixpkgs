{ lib
, buildMozillaMach
, cacert
, fetchFromGitHub
, fetchurl
, git
, libdbusmenu-gtk3
, runtimeShell
, thunderbirdPackages
, icu
, fetchpatch2
}:

let
  thunderbird-unwrapped = thunderbirdPackages.thunderbird-115;

  version = "115.4.2";
  majVer = lib.versions.major version;

  betterbird-patches = fetchFromGitHub {
    owner = "Betterbird";
    repo = "thunderbird-patches";
    rev = "${version}-bb17";
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
    hash = "sha256-hfM1VzYD0TsjZik0MLXBAkD5ecyvbg7jn2pKdrzMEfo=";
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
    hash = "sha256-PAjj7FvIA7uB0yngkL4KYKZoYU1CF2qQTF5+sG2VLtI=";
  };

  extraPostPatch = thunderbird-unwrapped.extraPostPatch or "" + /* bash */ ''
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
    mainProgram = "betterbird";
    maintainers = with maintainers; [ SuperSandro2000 ];
    inherit (thunderbird-unwrapped.meta) platforms badPlatforms broken license;
  };
}).override {
  crashreporterSupport = false; # not supported
  geolocationSupport = false;
  webrtcSupport = false;

  pgoSupport = false; # console.warn: feeds: "downloadFeed: network connection unavailable"

  # Betterbird is broken the same way Thunderbird is regarding VTZONE parsing in
  # [this issue][1] which is ultimately due to a [bug in Unicode ICU][2].
  # Therefore, Betterbird should apply the same patch that Thunderbird does at
  # present (see ../thunderbird/packages.nix, or [permalink][3]).
  #
  # [1]: https://bugzilla.mozilla.org/show_bug.cgi?id=1843007
  # [2]: https://unicode-org.atlassian.net/browse/ICU-22132
  # [3]: https://github.com/NixOS/nixpkgs/blob/2c7f3c0fb7c08a0814627611d9d7d45ab6d75335/pkgs/applications/networking/mailreaders/thunderbird/packages.nix#L82
  icu = icu.overrideAttrs (attrs: {
    patches = attrs.patches ++ [(fetchpatch2 {
      url = "https://hg.mozilla.org/mozilla-central/raw-file/fb8582f80c558000436922fb37572adcd4efeafc/intl/icu-patches/bug-1790071-ICU-22132-standardize-vtzone-output.diff";
      stripLen = 3;
      hash = "sha256-MGNnWix+kDNtLuACrrONDNcFxzjlUcLhesxwVZFzPAM=";
    })];
  });
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
