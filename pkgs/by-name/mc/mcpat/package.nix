{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "mcpat";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "HewlettPackard";
    repo = "mcpat";
    tag = "v${version}";
    hash = "sha256-sr7H2vBOTyI59d3itVNqRVy1fR/83ZrTGl5s4I+g0Tw=";
  };

  postPatch = ''
    substituteInPlace mcpat.mk \
      --replace-fail "CXX = g++ -m32" "CXX = g++" \
      --replace-fail "CC  = gcc -m32" "CC  = gcc"
  ''
  + lib.optionalString (!stdenv.hostPlatform.isx86) ''
    substituteInPlace mcpat.mk \
      --replace-fail "-msse2 -mfpmath=sse" ""
  '';

  buildPhase = ''
    runHook preBuild
    make -f makefile
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 -T mcpat "$out/bin/mcpat"
    runHook postInstall
  '';

  meta = {
    description = "Integrated power, area, and timing modeling framework for multicore and manycore architectures";
    homepage = "http://www.hpl.hp.com/research/mcpat/";
    changelog = "https://github.com/HewlettPackard/mcpat/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ hakan-demirli ];
    platforms = lib.platforms.linux;
    mainProgram = "mcpat";
  };
}
