{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  useFloat ? false,
  unstableGitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "fuzzylite";
  version = "6.0-unstable-2025-08-30";

  src = fetchFromGitHub {
    owner = "fuzzylite";
    repo = "fuzzylite";
    rev = "fe62b61ad0e301fbd8868d5fc3d76d7590c59636";
    hash = "sha256-p3ikdY3kfC8N7XsHHa3HzWI0blciWoxCHiEOOUt2yLY=";
  };

  outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "-Werror" "-Wno-error"
  '';

  nativeBuildInputs = [
    cmake
    ninja
  ];

  cmakeFlags = [
    "-DFL_BUILD_TESTS:BOOL=OFF"
    "-DFL_USE_FLOAT:BOOL=${if useFloat then "ON" else "OFF"}"
  ];

  # use unstable as latest release does not yet support cmake-4
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };

  meta = with lib; {
    description = "Fuzzy logic control library in C++";
    mainProgram = "fuzzylite";
    homepage = "https://fuzzylite.com";
    changelog = "https://github.com/fuzzylite/fuzzylite/${src.rev}/release/CHANGELOG";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.all;
  };
}
