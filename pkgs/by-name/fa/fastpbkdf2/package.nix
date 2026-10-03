{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastpbkdf2";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ctz";
    repo = "fastpbkdf2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QsFMhz510/DIN7PkKcMmLr1BR2KRoqTH3XCPGQkEXSU=";
  };

  buildInputs = [ openssl ];

  preBuild = ''
    makeFlagsArray=(CFLAGS="-std=c99 -O3 -g")
  '';

  installPhase = ''
    mkdir -p $out/{lib,include/fastpbkdf2}
    cp *.a $out/lib
    cp fastpbkdf2.h $out/include/fastpbkdf2
  '';

  meta = {
    description = "Fast PBKDF2-HMAC-{SHA1,SHA256,SHA512} implementation in C";
    homepage = "https://github.com/ctz/fastpbkdf2";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ ledif ];
  };
})
