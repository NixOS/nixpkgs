{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmcfp";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "mhekkel";
    repo = "libmcfp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e4scwaCwKU2M5FJ/+UTNDigazopQwGhCIqDatQX7ERw=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "Header only library that can collect configuration options from command line arguments";
    homepage = "https://github.com/mhekkel/libmcfp";
    changelog = "https://github.com/mhekkel/libmcfp/blob/${finalAttrs.src.rev}/changelog";
    license = licenses.bsd2;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
})
