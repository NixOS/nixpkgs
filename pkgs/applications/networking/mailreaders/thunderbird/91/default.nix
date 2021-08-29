{ stdenv, lib, callPackage, fetchurl }:

callPackage (import ../../../browsers/firefox/common.nix rec {
  pname = "thunderbird";
  ffversion = "91.0.1";
  application = "comm/mail";
  binaryName = pname;
  src = fetchurl {
    url = "mirror://mozilla/thunderbird/releases/${ffversion}/source/thunderbird-${ffversion}.source.tar.xz";
    sha512 = "54e1f3233c544cf28302496512aaf2a5fb5486aab070680e82cefbdd1d12a33867c638ced61e43958bae47e40ff551592a2cf4d537f98c22ed1df31c5d5bb09c";
  };
  patches = [
    ./no-buildconfig-90.patch
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
