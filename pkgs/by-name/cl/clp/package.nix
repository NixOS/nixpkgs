{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  coin-utils,
  zlib,
  osi,
}:

stdenv.mkDerivation rec {
  version = "1.17.10";
  pname = "clp";
  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "Clp";
    rev = "releases/${version}";
    hash = "sha256-9IlBT6o1aHAaYw2/39XrUis72P9fesmG3B6i/e+v3mM=";
  };

  nativeBuildInputs = [ pkg-config ];

  propagatedBuildInputs = [
    zlib
    coin-utils
    osi
  ];

  doCheck = true;

  meta = with lib; {
    license = licenses.epl20;
    homepage = "https://github.com/coin-or/Clp";
    description = "Open-source linear programming solver written in C++";
    mainProgram = "clp";
    platforms = platforms.darwin ++ platforms.linux;
    maintainers = [ maintainers.vbgl ];
  };
}
