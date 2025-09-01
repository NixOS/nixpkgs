{
  lib,
  fetchFromGitHub,
  rustPlatform,
  fetchurl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flaca";
  version = "3.4.2";

  lockFile = fetchurl {
    url = "https://github.com/Blobfolio/flaca/releases/download/v${finalAttrs.version}/Cargo.lock";
    hash = "sha256-6SpIqz/iLGVvOkwfiTcvf2EdlbVafQ+aHVc7taYLPDc=";
  };

  src = fetchFromGitHub {
    owner = "Blobfolio";
    repo = "flaca";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9fD+nfSe0Rk06d+o3hnMH2lC6OAFa10gDNiDW57lSTg=";
  };

  postUnpack = ''
    ln -s ${finalAttrs.lockFile} ${finalAttrs.src.name}/Cargo.lock
  '';

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  cargoHash = "sha256-LVY1+Nvcy7WoJ7Bsf1rgrdTzLMRqpquDXD8X3X8jX20=";

  meta = with lib; {
    description = "CLI tool to losslessly compress JPEG and PNG images";
    longDescription = "A CLI tool for x86-64 Linux machines that simplifies the task of maximally, losslessly compressing JPEG and PNG images for use in production web environments";
    homepage = "https://github.com/Blobfolio/flaca";
    changelog = "https://github.com/Blobfolio/flaca/releases/tag/v${finalAttrs.version}";
    maintainers = with maintainers; [ zzzsy ];
    platforms = platforms.linux;
    license = licenses.wtfpl;
    mainProgram = "flaca";
  };
})
