{ stdenv, lib, callPackage, fetchurl }:

callPackage (import ../../../browsers/firefox/common.nix rec {
  pname = "thunderbird";
  ffversion = "91.0";
  application = "comm/mail";
  binaryName = pname;
  src = fetchurl {
    url = "mirror://mozilla/thunderbird/releases/${ffversion}/source/thunderbird-${ffversion}.source.tar.xz";
    sha512 = "f3fcaff97b37ef41850895e44fbd2f42b0f1cb982542861bef89ef7ee606c6332296d61f666106be9455078933a2844c46bf243b71cc4364d9ff457d9c808a7a";
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
