{ lib, stdenv, fetchFromGitHub
, cmake, qt6, libarchive, pcre2, protobuf, gperftools, blas
}:

let
  rev = "f8a2dba0a63989c6b3a7be36f736ed478cad1dd2";

in stdenv.mkDerivation (finalAttrs: {
  pname = "translatelocally";
  version = "unstable-2023-08-25";

  src = fetchFromGitHub {
    owner = "XapaJIaMnu";
    repo = "translateLocally";
    inherit rev;
    hash = "sha256-uUdDi0CwCR/FQjw5D2s088d/Tp7NQOI0ia30oOhlGoc=";
    fetchSubmodules = true;
  };

  patches = [
    ./version_without_git.patch
  ];

  postPatch = ''
    echo '#define GIT_REVISION "${rev} ${finalAttrs.version}"' > \
      3rd_party/bergamot-translator/3rd_party/marian-dev/src/common/git_revision.h
  '';

  nativeBuildInputs = [
    cmake
    protobuf
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qttools
    qt6.qtbase
    qt6.qtsvg
    libarchive
    pcre2
    protobuf
    gperftools  # provides tcmalloc
    blas
  ];

  cmakeFlags = [
    "-DBLAS_LIBRARIES=-lblas"
    "-DCBLAS_LIBRARIES=-lcblas"
  ];

  meta = with lib; {
    mainProgram = "translateLocally";
    homepage = "https://translatelocally.com/";
    description = "Fast and secure translation on your local machine, powered by marian and Bergamot.";
    license = licenses.mit;
    maintainers = with maintainers; [ pacien ];
    platforms = platforms.linux;

    # https://github.com/XapaJIaMnu/translateLocally/issues/150
    broken = stdenv.isAarch64;
  };
})
