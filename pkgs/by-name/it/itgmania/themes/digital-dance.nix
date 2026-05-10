{
  lib,
  stdenv,
  fetchFromCodeberg,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "digital-dance";
  version = "1.1.3-unstable-2026-04-29";

  src = fetchFromCodeberg {
    owner = "JNero";
    repo = "Digital-Dance-ITGMania";
    rev = "a26bc9f19be8b899ed5af35c01cdd21fe48ec94f";
    hash = "sha256-4A87hM+yG6mKfYdC2fZ5lhSDVVH4FPtXStkjC95CcLs=";
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
