{
  lib,
  stdenv,
  fetchFromGitHub,
  gawk,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "awkaster";
  version = "0-unstable-2023-01-21";

  src = fetchFromGitHub {
    owner = "TheMozg";
    repo = "awk-raycaster";
    rev = "ac7f1b03554ca1c662ea2951cdd9f0b586075890";
    hash = "sha256-g8jrVCQsdEASzE0HUpACQIhMslXbBpMH9Z7+rYVwEqg=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 awkaster.awk \
                    $out/share/awkaster/awkaster.awk

    makeWrapper ${gawk}/bin/gawk \
                $out/bin/awkaster \
                --add-flags "-f $out/share/awkaster/awkaster.awk"

    runHook postInstall
  '';

  meta = {
    description = "Pseudo-3D raycasting shooter written completely in gawk";
    homepage = "https://github.com/TheMozg/awk-raycaster";
    mainProgram = "awkaster";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
