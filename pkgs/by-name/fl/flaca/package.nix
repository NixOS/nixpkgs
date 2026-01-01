{
  lib,
  fetchFromGitHub,
  rustPlatform,
  fetchurl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flaca";
<<<<<<< HEAD
  version = "3.5.3";

  lockFile = fetchurl {
    url = "https://github.com/Blobfolio/flaca/releases/download/v${finalAttrs.version}/Cargo.lock";
    hash = "sha256-NNeq8qr+z0s98mgFYyUu9aNRqaAi2CZfQx0vQzSzOc8=";
=======
  version = "3.4.2";

  lockFile = fetchurl {
    url = "https://github.com/Blobfolio/flaca/releases/download/v${finalAttrs.version}/Cargo.lock";
    hash = "sha256-6SpIqz/iLGVvOkwfiTcvf2EdlbVafQ+aHVc7taYLPDc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  src = fetchFromGitHub {
    owner = "Blobfolio";
    repo = "flaca";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-Fh+nWnAG87NL3scr/y2jCNqaeJtEwi4nCYTGwnmEsIQ=";
=======
    hash = "sha256-9fD+nfSe0Rk06d+o3hnMH2lC6OAFa10gDNiDW57lSTg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postUnpack = ''
    ln -s ${finalAttrs.lockFile} ${finalAttrs.src.name}/Cargo.lock
  '';

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

<<<<<<< HEAD
  cargoHash = "sha256-yHkUsxJppHhIpgX7Vtrs8TCy43xaNpqoVkMZ0msr02k=";

  meta = {
=======
  cargoHash = "sha256-LVY1+Nvcy7WoJ7Bsf1rgrdTzLMRqpquDXD8X3X8jX20=";

  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "CLI tool to losslessly compress JPEG and PNG images";
    longDescription = "A CLI tool for x86-64 Linux machines that simplifies the task of maximally, losslessly compressing JPEG and PNG images for use in production web environments";
    homepage = "https://github.com/Blobfolio/flaca";
    changelog = "https://github.com/Blobfolio/flaca/releases/tag/v${finalAttrs.version}";
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ zzzsy ];
    platforms = lib.platforms.linux;
    license = lib.licenses.wtfpl;
=======
    maintainers = with maintainers; [ zzzsy ];
    platforms = platforms.linux;
    license = licenses.wtfpl;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "flaca";
  };
})
