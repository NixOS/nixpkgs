{ lib, stdenv, fetchurl, pkg-config, libsamplerate, libsndfile, fftw
, lv2, jdk_headless
, vamp-plugin-sdk, ladspaH, meson, ninja, darwin }:

stdenv.mkDerivation rec {
  pname = "rubberband";
  version = "4.0.0";

  src = fetchurl {
    url = "https://breakfastquay.com/files/releases/rubberband-${version}.tar.bz2";
    hash = "sha256-rwUDE+5jvBizWy4GTl3OBbJ2qvbRqiuKgs7R/i+AKOk=";
  };

  nativeBuildInputs = [ pkg-config meson ninja jdk_headless ];
  buildInputs = [ libsamplerate libsndfile fftw vamp-plugin-sdk ladspaH lv2 ] ++ lib.optionals stdenv.hostPlatform.isDarwin
    (with darwin.apple_sdk.frameworks; [Accelerate CoreGraphics CoreVideo]);
  makeFlags = [ "AR:=$(AR)" ];

  # TODO: package boost-test, so we can run the test suite. (Currently it fails
  # to find libboost_unit_test_framework.a.)
  mesonFlags = [ "-Dtests=disabled" ];
  doCheck = false;

  meta = with lib; {
    description = "High quality software library for audio time-stretching and pitch-shifting";
    homepage = "https://breakfastquay.com/rubberband/";
    # commercial license available as well, see homepage. You'll get some more optimized routines
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.all;
  };
}
