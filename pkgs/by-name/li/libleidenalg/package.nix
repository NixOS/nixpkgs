{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  igraph,
}:

stdenv.mkDerivation rec {
  pname = "libleidenalg";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "vtraag";
    repo = "libleidenalg";
    rev = "refs/tags/${version}";
    hash = "sha256-hEES/OHvgN0yRDp5ZBZTCQfWr1j7s8NqE+Sp9WMHEEY=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    igraph
  ];

  meta = {
    changelog = "https://github.com/vtraag/libleidenalg/blob/${version}/CHANGELOG";
    description = "C++ library of Leiden algorithm";
    homepage = "https://github.com/vtraag/libleidenalg";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.all;
  };
}
