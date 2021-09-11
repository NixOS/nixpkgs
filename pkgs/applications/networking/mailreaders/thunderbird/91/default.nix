{ stdenv, lib, callPackage, fetchurl }:

callPackage (import ../../../browsers/firefox/common.nix rec {
  pname = "thunderbird";
  ffversion = "91.1.0";
  application = "comm/mail";
  binaryName = pname;
  src = fetchurl {
    url = "mirror://mozilla/thunderbird/releases/${ffversion}/source/thunderbird-${ffversion}.source.tar.xz";
    sha512 = "3zl164k4lp7m33s0097cbf8kbb4v1rs1q2qr58bsrdpc65fh20k88s1yd9h5phvydml14y6b1p2fhx723dcrcfkagdjhp3wsqjzyrf4";
  };
  patches = [
    ./no-buildconfig-90.patch

    # There is a bug in Thunderbird 91 where add-ons are required
    # to be signed when the build is run with default settings.
    # https://bugzilla.mozilla.org/show_bug.cgi?id=1727113
    # https://phabricator.services.mozilla.com/D124361
    ./D124361.diff
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
