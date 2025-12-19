{
  lib,
  fetchFromGitHub,
  rustPlatform,
  fetchurl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flaca";
  version = "3.5.3";

  lockFile = fetchurl {
    url = "https://github.com/Blobfolio/flaca/releases/download/v${finalAttrs.version}/Cargo.lock";
    hash = "sha256-NNeq8qr+z0s98mgFYyUu9aNRqaAi2CZfQx0vQzSzOc8=";
  };

  src = fetchFromGitHub {
    owner = "Blobfolio";
    repo = "flaca";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Fh+nWnAG87NL3scr/y2jCNqaeJtEwi4nCYTGwnmEsIQ=";
  };

  postUnpack = ''
    ln -s ${finalAttrs.lockFile} ${finalAttrs.src.name}/Cargo.lock
  '';

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  cargoHash = "sha256-yHkUsxJppHhIpgX7Vtrs8TCy43xaNpqoVkMZ0msr02k=";

  meta = {
    description = "CLI tool to losslessly compress JPEG and PNG images";
    longDescription = "A CLI tool for x86-64 Linux machines that simplifies the task of maximally, losslessly compressing JPEG and PNG images for use in production web environments";
    homepage = "https://github.com/Blobfolio/flaca";
    changelog = "https://github.com/Blobfolio/flaca/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ zzzsy ];
    platforms = lib.platforms.linux;
    license = lib.licenses.wtfpl;
    mainProgram = "flaca";
  };
})
