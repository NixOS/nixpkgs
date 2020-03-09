{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "timewarrior";
  version = "1.2.0";

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "timewarrior";
    rev = "v${version}";
    sha256 = "0ci8kb7gdp1dsv6xj30nbz8lidrmn50pbriw26wv8mdhs17rfk7w";
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

