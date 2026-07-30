{
  lib,
  stdenv,
  fetchFromCodeberg,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "digital-dance";
  version = "1.1.5-unstable-2026-07-28";

  src = fetchFromCodeberg {
    owner = "JNero";
    repo = "Digital-Dance-ITGMania";
    rev = "2f3f1bd5b5e7e699bc842836634b50d424e6f778";
    hash = "sha256-jNxN6/7KDPMlDMnQpj3MIk8Kt2rllT/f0fvmeMB5z1c=";
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
