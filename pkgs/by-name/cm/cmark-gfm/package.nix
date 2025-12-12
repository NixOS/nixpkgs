{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation rec {
  pname = "cmark-gfm";
  version = "0.29.0.gfm.13";

  src = fetchFromGitHub {
    owner = "github";
    repo = "cmark-gfm";
    rev = version;
    sha256 = "sha256-HiSGtRsSbW03R6aKoMVVFOLrwP5aXtpeXUC/bE5M/qo=";
  };

  # Fix the build with CMake 4.
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "cmake_minimum_required(VERSION 3.0)" \
      "cmake_minimum_required(VERSION 3.13)"
  '';

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  meta = {
    description = "GitHub's fork of cmark, a CommonMark parsing and rendering library and program in C";
    mainProgram = "cmark-gfm";
    homepage = "https://github.com/github/cmark-gfm";
    changelog = "https://github.com/github/cmark-gfm/raw/${version}/changelog.txt";
    maintainers = with lib.maintainers; [ cyplo ];
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd2;
  };
}
