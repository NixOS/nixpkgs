{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  pcsclite,
  libzip,
  help2man,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libykneomgr";
  version = "0.1.8";

  src = fetchurl {
    url = "https://developers.yubico.com/libykneomgr/Releases/libykneomgr-${finalAttrs.version}.tar.gz";
    sha256 = "12gqblz400kr11m1fdr1vvwr85lgy5v55zy0cf782whpk8lyyj97";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    pcsclite
    libzip
    help2man
  ];

  configureFlags = [
    "--with-backend=pcsc"
  ];

  meta = {
    description = "C library to interact with the CCID-part of the Yubikey NEO";
    homepage = "https://developers.yubico.com/libykneomgr";
    license = lib.licenses.bsd3;
    mainProgram = "ykneomgr";
    platforms = lib.platforms.unix;
  };
})
