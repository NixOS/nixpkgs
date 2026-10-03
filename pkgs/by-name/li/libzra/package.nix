{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "libzra";
  version = "0-unstable-2020-09-11";

  src = fetchFromGitHub {
    owner = "zraorg";
    repo = "zra";
    rev = "57abf2774dfc4624f14a0bc5bba71f044ce54a38";
    hash = "sha256-hE3zQvf90Q+iSnSTveYGj5mGyOWnXNZeAUAAVY3ENIM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  # in submodule dev as of 1.4.7
  postPatch = ''
    (cd submodule/zstd && patch -Np1 < ${./fix-pkg-config.patch})

    substituteInPlace submodule/zstd/build/cmake/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8.9 FATAL_ERROR)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    homepage = "https://github.com/zraorg/ZRA";
    description = "Library for ZStandard random access";
    platforms = lib.platforms.all;
    maintainers = [ ];
    license = lib.licenses.bsd3;
  };
}
