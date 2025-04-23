{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "judgel";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "udontur";
    repo = "judgel";
    tag = "v${version}";
    hash = "sha256-fIWKPfeSCvEbvLp6J5SMULl4aIfMgCTZHWqst2ihAeE=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm755 ./judgel $out/bin/judgel
    runHook postInstall
  '';

  meta = {
    description = "Simple local C++ CLI judge";
    homepage = "https://github.com/udontur/judgel";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ udontur ];
    mainProgram = "judgel";
    platforms = lib.intersectLists lib.platforms.linux lib.platforms.x86;
  };
}
