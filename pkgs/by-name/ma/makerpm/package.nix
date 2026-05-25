{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  libarchive,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.0";
  pname = "makerpm";

  installPhase = ''
    mkdir -p $out/bin
    cp makerpm $out/bin
  '';

  buildInputs = [
    zlib
    libarchive
    openssl
  ];

  src = fetchFromGitHub {
    owner = "ivan-tkatchev";
    repo = "makerpm";
    rev = finalAttrs.version;
    sha256 = "089dkbh5705ppyi920rd0ksjc0143xmvnhm8qrx93rsgwc1ggi1y";
  };

  meta = {
    homepage = "https://github.com/ivan-tkatchev/makerpm/";
    description = "Clean, simple RPM packager reimplemented completely from scratch";
    mainProgram = "makerpm";
    license = lib.licenses.free;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.ivan-tkatchev ];
  };
})
