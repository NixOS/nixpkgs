{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  jdupes,
}:

stdenvNoCC.mkDerivation {
  pname = "fcitx5-mellow-themes";
  version = "0-unstable-2026-09-10";

  src = fetchFromGitHub {
    owner = "sanweiya";
    repo = "fcitx5-mellow-themes";
    rev = "2c93b0ea3418a55c03f526d963c84a7ccde2c1e9";
    hash = "sha256-y7Q7BgObG99l0+8UVn24TibmUK3Xdq+/1N/G4o9eYAY=";
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
