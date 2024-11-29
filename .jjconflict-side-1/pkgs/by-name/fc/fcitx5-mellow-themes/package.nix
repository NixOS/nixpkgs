{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  jdupes,
}:

stdenvNoCC.mkDerivation {
  pname = "fcitx5-mellow-themes";
  version = "0-unstable-2024-11-11";

  src = fetchFromGitHub {
    owner = "sanweiya";
    repo = "fcitx5-mellow-themes";
    rev = "9694953eb1bd6c9363cf9c76833347bfa5ffd886";
    hash = "sha256-+wJOPUmUkR/uR9zdFyrV86D6nsYnC94zHXkEfjmAVjs=";
  };

  nativeBuildInputs = [ jdupes ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fcitx5/themes
    cp -r *mellow* $out/share/fcitx5/themes
    jdupes --quiet --link-soft --recurse $out/share

    runHook postInstall
  '';

  meta = {
    description = "Aesthetic, modern fcitx5 theme featuring rounded rectangle design";
    homepage = "https://github.com/sanweiya/fcitx5-mellow-themes";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      Guanran928
      zendo
    ];
  };
}
