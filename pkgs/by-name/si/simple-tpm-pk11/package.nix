{
  lib,
  stdenv,
  fetchFromGitHub,
  trousers,
  openssl,
  opencryptoki,
  autoreconfHook,
  libtool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "simple-tpm-pk11";
  version = "0.07";

  src = fetchFromGitHub {
    owner = "ThomasHabets";
    repo = "simple-tpm-pk11";
    rev = finalAttrs.version;
    sha256 = "sha256-wJ0U4ZNg60+XJTSAMs9gaMTWVePE5dfv5cZWDqwnSlY=";
  };

  nativeBuildInputs = [
    autoreconfHook
    libtool
  ];
  buildInputs = [
    trousers
    openssl
    opencryptoki
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Simple PKCS11 provider for TPM chips";
    longDescription = ''
      A simple library for using the TPM chip to secure SSH keys.
    '';
    homepage = "https://github.com/ThomasHabets/simple-tpm-pk11";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
