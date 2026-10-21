{
  lib,
  stdenv,
  fetchurl,
  openssl,
  getconf,
  util-linux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scrypt";
  version = "1.3.3";

  src = fetchurl {
    url = "https://www.tarsnap.com/scrypt/scrypt-${finalAttrs.version}.tgz";
    sha256 = "sha256-HCcQUX6ZjqrC6X2xHwkuNxOeaYhrIaGyZh9k4TAhWuk=";
  };

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  configureFlags = [ "--enable-libscrypt-kdf" ];

  buildInputs = [ openssl ];

  nativeBuildInputs = [ getconf ];

  patchPhase = ''
    for f in Makefile.in autotools/Makefile.am libcperciva/cpusupport/Build/cpusupport.sh configure ; do
      substituteInPlace $f --replace "command -p " ""
    done

    patchShebangs tests/test_scrypt.sh
  '';

  doCheck = true;
  checkTarget = "test";
  nativeCheckInputs = lib.optionals stdenv.hostPlatform.isLinux [ util-linux ];

  meta = {
    description = "Encryption utility";
    mainProgram = "scrypt";
    homepage = "https://www.tarsnap.com/scrypt.html";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ thoughtpolice ];
  };
})
