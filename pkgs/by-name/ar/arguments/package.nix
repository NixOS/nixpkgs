{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "arguments";
  version = "1.4.60-unstable-2023-01-18";

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = "arguments";
    rev = "ed7c4c126b800d4312469e3cd3999a31e96fed0e";
    hash = "sha256-1QxVZ17zSqx5P9nGAXHf7Fj86fuGn17PllGXFqyYJUo=";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = false; # test binary not built by cmake

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "CMAKE_MINIMUM_REQUIRED(VERSION 3.1)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    homepage = "https://github.com/BIC-MNI/arguments";
    description = "Library for argument handling for MINC programs";
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
  };
}
