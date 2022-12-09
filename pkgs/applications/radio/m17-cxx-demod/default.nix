{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, boost, codec2 }:

stdenv.mkDerivation rec {
  pname = "m17-cxx-demod";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "mobilinkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-mvppkFBmmPVqvlqIqrbwGrOBih5zS5sZrV/usEhHiws=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ codec2 boost ];

  meta = with lib; {
    description = "M17 Demodulator in C++";
    homepage = "https://github.com/mobilinkd/m17-cxx-demod";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = teams.c3d2.members;
  };
}
