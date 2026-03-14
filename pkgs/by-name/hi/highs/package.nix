{
  lib,
  stdenv,
  fetchFromGitHub,
  clang,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highs";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "ERGO-Code";
    repo = "HiGHS";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vcKDye6Uar1/5sDBIj8fi+hTYqraRs1Awp6068/FVP4=";
  };

  strictDeps = true;

  outputs = [ "out" ];

  doInstallCheck = true;

  installCheckPhase = ''
    "$out/bin/highs" --version
  '';

  nativeBuildInputs = [
    clang
    cmake
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/ERGO-Code/HiGHS";
    description = "Linear optimization software";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "highs";
    maintainers = with lib.maintainers; [
      galabovaa
      silky
    ];
  };
})
