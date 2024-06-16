{ lib, stdenv, fetchFromGitHub, pkg-config, coin-utils, zlib, osi }:

stdenv.mkDerivation rec {
  version = "1.17.9";
  pname = "clp";
  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "Clp";
    rev = "releases/${version}";
    hash = "sha256-kHCDji+yIf5mCoxKB2b/HaATGmwwIAPEV74tthIMeMY=";
  };

  nativeBuildInputs = [ pkg-config ];

  propagatedBuildInputs = [ zlib coin-utils osi ];

  doCheck = true;

  meta = with lib; {
    license = licenses.epl20;
    homepage = "https://github.com/coin-or/Clp";
    description = "An open-source linear programming solver written in C++";
    mainProgram = "clp";
    platforms = platforms.darwin ++ platforms.linux;
    maintainers = [ maintainers.vbgl ];
  };
}
