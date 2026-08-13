{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  jdupes,
}:

stdenvNoCC.mkDerivation {
  pname = "fcitx5-inflex-themes";
  version = "0-unstable-2024-11-11";

  src = fetchFromGitHub {
    owner = "sanweiya";
    repo = "fcitx5-inflex-themes";
    rev = "86d0a36eae2145de38d9c8bcfcb59f3b5ab6cb37";
    hash = "sha256-YyToQdVieRepGeW1CRBFH9VO7CtO8r7xCO9/79V+vlA=";
  };

  nativeBuildInputs = [ jdupes ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fcitx5/themes
    cp -r *inflex* $out/share/fcitx5/themes
    jdupes --quiet --link-soft --recurse $out/share

    runHook postInstall
  '';

  meta = {
    description = "Aesthetic, modern fcitx5 theme featuring sharp-edged rectangle design";
    homepage = "https://github.com/sanweiya/fcitx5-inflex-themes";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ Guanran928 ];
  };
}
