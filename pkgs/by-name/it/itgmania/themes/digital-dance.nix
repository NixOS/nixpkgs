{
  lib,
  stdenv,
  fetchFromCodeberg,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "digital-dance";
  version = "1.1.3-unstable-2026-05-09";

  src = fetchFromCodeberg {
    owner = "JNero";
    repo = "Digital-Dance-ITGMania";
    rev = "aca637dc8f2b47a254bead472da6129f28fa55fd";
    hash = "sha256-uKweTqF4q0YsOIOpEi5v+N60YvctDF9stcP+GYlUuO4=";
  };

  postInstall = ''
    mkdir -p "$out/itgmania/Themes/Digital Dance"
    mv * "$out/itgmania/Themes/Digital Dance"
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Theme for ITGMania to (hopefully) utilize all of it's features and more";
    homepage = "https://codeberg.org/JNero/Digital-Dance-ITGMania";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ungeskriptet ];
  };
})
