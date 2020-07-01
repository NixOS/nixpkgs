{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "timewarrior";
  version = "1.3.0";

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "timewarrior";
    rev = "v${version}";
    sha256 = "1aijh1ad7gpa61cn7b57w24vy7fyjj0zx5k9z8d6m1ldzbw589cl";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "A command-line time tracker";
    homepage = "https://timewarrior.net";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer mrVanDalo ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}

