{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmcfp";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "mhekkel";
    repo = "libmcfp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7Oy7qEXIAJ50NXL4+Mm67WrivpubDz7uLWZ3YVzTFxA=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Header only library that can collect configuration options from command line arguments";
    homepage = "https://github.com/mhekkel/libmcfp";
    changelog = "https://github.com/mhekkel/libmcfp/blob/${finalAttrs.src.rev}/changelog";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ natsukium ];
    platforms = lib.platforms.unix;
  };
})
