{ lib, stdenv, fetchFromGitHub
, cmake, qt6, libarchive, pcre2, protobuf, gperftools, blas
, runCommand, translatelocally, translatelocally-models
}:

let
  rev = "a210037760ca3ca9016ca1831c97531318df70fe";

in stdenv.mkDerivation (finalAttrs: {
  pname = "translatelocally";
  version = "unstable-2023-09-20";

  src = fetchFromGitHub {
    owner = "XapaJIaMnu";
    repo = "translateLocally";
    inherit rev;
    hash = "sha256-T7cZdR09yDrPTwYxvDIaKTdV4mrB+gTHYVfch5BQ+PE=";
    fetchSubmodules = true;
  };

  patches = [
    ./version_without_git.patch
  ];

  postPatch = ''
    echo '#define GIT_REVISION "${rev} ${finalAttrs.version}"' > \
      3rd_party/bergamot-translator/3rd_party/marian-dev/src/common/git_revision.h
  '';

  # https://github.com/XapaJIaMnu/translateLocally/blob/81ed8b9/.github/workflows/build.yml#L330
  postConfigure = lib.optionalString stdenv.isAarch64 ''
    bash ../cmake/fix_ruy_build.sh .. .
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

  passthru.tests = {
    cli-translate = runCommand "${finalAttrs.pname}-test-cli-translate" {
      nativeBuildInputs = [
        translatelocally
        translatelocally-models.fr-en-tiny
      ];
    } ''
      export LC_ALL="C.UTF-8"
      echo "Bonjour" | translateLocally -m fr-en-tiny > $out
      diff "$out" <(echo "Hello")
    '';
  };

  meta = with lib; {
    mainProgram = "translateLocally";
    homepage = "https://translatelocally.com/";
    description = "Fast and secure translation on your local machine, powered by marian and Bergamot.";
    license = licenses.mit;
    maintainers = with maintainers; [ pacien ];
    platforms = platforms.linux;
  };
})
