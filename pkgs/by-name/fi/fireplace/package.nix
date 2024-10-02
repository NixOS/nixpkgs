{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:
stdenv.mkDerivation {
  pname = "fireplace";
  version = "0-unstable-2020-02-02";

  buildInputs = [ ncurses ];

  installPhase = ''
    runHook preInstall

    install -Dm555 fireplace -t $out/bin

    runHook postInstall
  '';

  src = fetchFromGitHub {
    owner = "Wyatt915";
    repo = "fireplace";
    rev = "aa2070b73be9fb177007fc967b066d88a37e3408";
    hash = "sha256-2NUE/zaFoGwkZxgvVCYXxToiL23aVUFwFNlQzEq9GEc=";
  };

  meta = {
    description = "Cozy fireplace in your terminal";
    homepage = "https://github.com/Wyatt915/fireplace";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      multivac61
    ];
    mainProgram = "fireplace";
    platforms = lib.platforms.all;
  };
}
