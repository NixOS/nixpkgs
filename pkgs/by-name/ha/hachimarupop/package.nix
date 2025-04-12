{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "hachimarupop";
  version = "unstable-2022-07-11";

  src = fetchFromGitHub {
    owner = "noriokanisawa";
    repo = "HachiMaruPop";
    rev = "67d96c274032f5a2e1d33c1ec53498fde9110079";
    hash = "sha256-b1moyTVy0hHGu9/LrQ9k6Isd/LYTSxiuqz3BzrYVbXY=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm444 fonts/ttf/*.ttf -t $out/share/fonts/truetype/
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/noriokanisawa/HachiMaruPop";
    description = "Cute, Japanese font";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.all;
  };
}
