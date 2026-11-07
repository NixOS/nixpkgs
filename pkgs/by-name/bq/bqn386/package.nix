{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "bqn386";
  version = "0-unstable-2025-03-23";

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "BQN386";
    rev = "4d8b9f668ba76a15ca9cd44d9bfedaf95a4c0d96";
    hash = "sha256-7GW4W08d5sB9EIlPPTol29nWA64pPF+8PvrugrRkXtA=";
  };

  outputs = [
    "out"
    "woff2"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm444 -t $out/share/fonts/truetype *.ttf
    install -Dm444 -t $woff2/share/fonts/woff2 *.woff2

    runHook postInstall
  '';

  meta = {
    description = "APL and BQN font extending on APL386";
    homepage = "https://dzaima.github.io/BQN386/";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ skykanin ];
    platforms = lib.platforms.all;
  };
}
