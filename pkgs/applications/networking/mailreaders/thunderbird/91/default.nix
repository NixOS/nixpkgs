{ stdenv, lib, callPackage, fetchurl }:

callPackage (import ../../../browsers/firefox/common.nix rec {
  pname = "thunderbird";
  ffversion = "91.0.3";
  application = "comm/mail";
  binaryName = pname;
  src = fetchurl {
    url = "mirror://mozilla/thunderbird/releases/${ffversion}/source/thunderbird-${ffversion}.source.tar.xz";
    sha512 = "1c7b4c11066ab64ee1baa9f07bc6bd4478c2ece0bcf8ac381c2f0774582bb781b8151b54326cd38742d039c5de718022649d804dfceaf142863249b1edb68e1e";
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
