{ lib, stdenv, fetchFromGitHub, fetchpatch, libsndfile, libsamplerate, liblo, libjack2 }:

stdenv.mkDerivation {
  pname = "dirt";
  version = "unstable-2018-01-01";
  src = fetchFromGitHub {
    repo = "Dirt";
    owner = "tidalcycles";
    rev = "b09604c7d8e581bc7799d7e2ad293e7cdd254bda";
    sha256 = "13adglk2d31d7mswfvi02b0rjdhzmsv11cc8smhidmrns3f9s96n";
    fetchSubmodules = true;
  };
  patches = [
    # Pull patch pending upstream inclusion for upstream gcc-10 support:
    #  https://github.com/tidalcycles/Dirt/pull/65
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/tidalcycles/Dirt/commit/43fd267745d486228c4185b4fcbd7d9fbc362cc2.patch";
      sha256 = "08r34ylzs31wwf0la995pb149ccq0vr7qg4792pkhca57zi0bff8";
    })
  ];
  buildInputs = [ libsndfile libsamplerate liblo libjack2 ];
  postPatch = ''
    sed -i "s|./samples|$out/share/dirt/samples|" dirt.c
  '';
  makeFlags = ["PREFIX=$(out)"];
  postInstall = ''
    mkdir -p $out/share/dirt/
    cp -r samples $out/share/dirt/
  '';

  meta = with lib; {
    description = "An unimpressive thingie for playing bits of samples with some level of accuracy";
    homepage = "https://github.com/tidalcycles/Dirt";
    license = licenses.gpl3;
    maintainers = with maintainers; [ anderspapitto ];
    platforms = with platforms; linux;
  };
}
