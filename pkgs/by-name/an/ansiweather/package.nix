{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  curl,
  jq,
  bc,
  coreutils,
  findutils,
  gnugrep,
  gnused,
  makeWrapper,
  installShellFiles,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ansiweather";
  version = "1.19.0-unstable-2025-12-29";

  src = fetchFromGitHub {
    owner = "fcambus";
    repo = "ansiweather";
    rev = "39f43f31659972415be2d19889f0f9540db752d7";
    hash = "sha256-buKfpzD4o+iQjX2djF3qF9HMb9qyU9OU5p8VnFxMv8s=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 ansiweather $out/bin/ansiweather

    installManPage ansiweather.1

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/ansiweather \
      --set PATH ${
        lib.makeBinPath [
          coreutils
          findutils
          gnugrep
          gnused
          jq
          bc
          curl
        ]
      }
  '';

  meta = {
    description = "Display weather in terminal with ANSI colors and Unicode symbols";
    homepage = "https://github.com/fcambus/ansiweather";
    mainProgram = "ansiweather";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
