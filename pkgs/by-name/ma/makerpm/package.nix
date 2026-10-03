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
    hash = "sha256-PsT3AuNP55F6xqhCu2sfJAAm9QQtA5Giv7eAU+CaLSE=";
  };

  meta = {
    homepage = "https://github.com/ivan-tkatchev/makerpm/";
    description = "Clean, simple RPM packager reimplemented completely from scratch";
    mainProgram = "makerpm";
    license = lib.licenses.free;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
