{
  lib,
  stdenv,
  fetchFromGitea,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "l8w8jwt";
  version = "2.5.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "GlitchedPolygons";
    repo = "l8w8jwt";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-aR3r84AYvCNx3jm9lB1qtbbEh9rU3LTkI+TK9LPQaPk=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DL8W8JWT_PACKAGE=On"
    (lib.cmakeBool "L8W8JWT_ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  # chillibuff header isn't installed correctly
  preConfigure = ''
    mv lib/chillbuff/include/chillbuff.h include/
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    ./run_tests
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p -m777 $out/include $out/lib64
    cp -pr $src/include/l8w8jwt $out/include
    cp -pr l8w8jwt/bin/release/libl8w8jwt.a $out/lib64

    runHook postInstall
  '';

  postPatch = ''
    substituteInPlace lib/chillbuff/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.1)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    description = "Minimal, OpenSSL-less and super lightweight JWT library written in C";
    homepage = "https://codeberg.org/GlitchedPolygons/l8w8jwt";
    changelog = "https://codeberg.org/GlitchedPolygons/l8w8jwt/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jherland ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isAarch64;
  };
})
