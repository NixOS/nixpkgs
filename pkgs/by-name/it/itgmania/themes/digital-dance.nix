{
  lib,
  stdenv,
  fetchFromCodeberg,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "digital-dance";
  version = "1.1.3-unstable-2026-06-22";

  src = fetchFromCodeberg {
    owner = "JNero";
    repo = "Digital-Dance-ITGMania";
    rev = "14d3d31a4f79f1557e3515de41a7907130d7b163";
    hash = "sha256-e/lOhwI+Q4sMn0EL5sPMhCaxoN6eOLVLBs7bMOPJUxY=";
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
