{
  lib,
  stdenv,
  fetchFromCodeberg,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "digital-dance";
  version = "1.1.3-unstable-2026-04-19";

  src = fetchFromCodeberg {
    owner = "JNero";
    repo = "Digital-Dance-ITGMania";
    rev = "bfce7a6d719189a3eec1577b54256941e8d602a5";
    hash = "sha256-yrXdU73Jokm+nMMi8mtxdEL5+xuFj4sHIW+/nulcJJI=";
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
