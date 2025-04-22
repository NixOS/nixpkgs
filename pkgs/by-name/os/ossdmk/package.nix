{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "ossdmk";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "udontur";
    repo = "ossdmk";
    tag = "v${version}";
    hash = "sha256-QF3VJHxkw4K4BjpaL0+OA02cU9mSpLQkI70kBgxkGH0=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm755 ./ossdmk $out/bin/ossdmk
    runHook postInstall
  '';

  meta = {
    description = "Ontario Secondary School Diploma (OSSD) Mark Calculator CLI Tool";
    homepage = "https://github.com/udontur/ossdmk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ udontur ];
    mainProgram = "ossdmk";
    platforms = lib.platforms.linux;
  };
}
