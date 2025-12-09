{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fftw,
  catch2,
}:

stdenv.mkDerivation rec {
  pname = "libkeyfinder";
  version = "2.2.8";

  src = fetchFromGitHub {
    owner = "mixxxdj";
    repo = "libkeyfinder";
    rev = version;
    hash = "sha256-Et8u5j/ke9u2bwHFriPCCBiXkPel37gwx+kwuViAr4o=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ fftw ];

  nativeCheckInputs = [ catch2 ];

  doCheck = true;

  meta = with lib; {
    description = "Musical key detection for digital audio (C++ library)";
    homepage = "https://mixxxdj.github.io/libkeyfinder/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
