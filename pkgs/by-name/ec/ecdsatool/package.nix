{
  lib,
  stdenv,
  pkgs,
}:

stdenv.mkDerivation {
  version = "0.0.1";
  pname = "ecdsatool";

  src = pkgs.fetchFromGitHub {
    owner = "kaniini";
    repo = "ecdsatool";
    rev = "7c0b2c51e2e64d1986ab1dc2c57c2d895cc00ed1";
    hash = "sha256-U5jTa5YEHJQdMfxTmxcOCobGTt3Pk4b5lRlO+xMY6SM=";
  };

  configurePhase = ''
    runHook preConfigure

    ./autogen.sh
    ./configure --prefix=$out

    runHook postConfigure
  '';

  patches = [
    ./ctype-header-c99-implicit-function-declaration.patch
    ./openssl-header-c99-implicit-function-declaration.patch
  ];

  nativeBuildInputs = with pkgs; [
    openssl
    autoconf
    automake
  ];
  buildInputs = with pkgs; [ libuecc ];

  meta = {
    description = "Create and manipulate ECC NISTP256 keypairs";
    mainProgram = "ecdsatool";
    homepage = "https://github.com/kaniini/ecdsatool/";
    license = lib.licenses.free;
    platforms = lib.platforms.unix;
  };
}
