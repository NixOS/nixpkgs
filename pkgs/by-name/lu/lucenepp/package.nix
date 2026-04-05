{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  gtest,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "lucene++";
  version = "3.0.9-unstable-2026-01-25";

  src = fetchFromGitHub {
    owner = "luceneplusplus";
    repo = "LucenePlusPlus";
    rev = "f11e0895cf1dd7d6a68a0a736f13414f1e37ef7a";
    hash = "sha256-3q1iRWTbd+PHIBM5mCfJ1h5ssxBeyao/CkRhyvApND8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost
    gtest
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeBool "ENABLE_TEST" doCheck)
  ];

  # FIXME: 7 tests fail, https://github.com/luceneplusplus/LucenePlusPlus/issues/212
  doCheck = false;

  checkPhase = ''
    runHook preCheck
    LD_LIBRARY_PATH=$PWD/src/contrib:$PWD/src/core \
            src/test/lucene++-tester
    runHook postCheck
  '';

  meta = {
    description = "C++ port of the popular Java Lucene search engine";
    homepage = "https://github.com/luceneplusplus/LucenePlusPlus";
    license = with lib.licenses; [
      asl20
      lgpl3Plus
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ wineee ];
  };
}
