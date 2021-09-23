{ stdenv, lib, callPackage, fetchurl }:

callPackage (import ../../../browsers/firefox/common.nix rec {
  pname = "thunderbird";
  ffversion = "91.1.1";
  application = "comm/mail";
  binaryName = pname;
  src = fetchurl {
    url = "mirror://mozilla/thunderbird/releases/${ffversion}/source/thunderbird-${ffversion}.source.tar.xz";
    sha512 = "2da102f9ec42489fc785ccdabcc7fdbc826f2df5e8e76c65866a44a221e762f59647ea265fe4907c18f0d3f1e04199e809235b4587ea17bdc1155e829f57ff2f";
  };
  patches = [
  ];

  meta = with lib; {
    description = "A full-featured e-mail client";
    homepage = "https://thunderbird.net/";
    maintainers = with maintainers; [ eelco lovesegfault pierron vcunat ];
    platforms = platforms.unix;
    badPlatforms = platforms.darwin;
    broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                           # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
    license = licenses.mpl20;
  };

  updateScript = callPackage ./update.nix {
    attrPath = "thunderbird-unwrapped-91";
    versionKey = "ffversion";
  };
}) {
  webrtcSupport = false;
  geolocationSupport = false;
}
