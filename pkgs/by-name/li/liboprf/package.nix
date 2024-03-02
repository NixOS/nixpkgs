{ lib, fetchFromGitHub, stdenv, makeWrapper, libsodium }:

stdenv.mkDerivation rec {
  pname = "liboprf";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "stef";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "sha256-EHUz86JyKDdAJT+taqnjPfdqaGRNPHS7xqU6YA6jXS4=";
  };

  nativeBuildInputs = [ libsodium makeWrapper ];
  dontConfigure = true;

  buildPhase = ''
    cd src
    make'';

  installPhase = ''
    make install DESTDIR=$out
  '';

  meta = with lib; {
    description = "liboprf - library providing OPRF and Threshold OPRF based on libsodium";
    homepage = "https://github.com/stef/liboprf";
    license = licenses.lgpl3;
    maintainers = [ maintainers.gepardgame ];
  };
}
