{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmcfp";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "mhekkel";
    repo = "libmcfp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qKmSkVuxY5kXQ1eSs/T500lFpCLzU3sXAoUmpXhTUp4=";
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
