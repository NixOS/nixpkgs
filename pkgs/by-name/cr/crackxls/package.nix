{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoconf,
  automake,
  openssl,
  libgsf,
  gmp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "crackxls";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "GavinSmith0123";
    repo = "crackxls2003";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-CJFC4iKHHpSRQBdotmum7NjpPNUjbB6cSCs5HMXnjO8=";
  };

  nativeBuildInputs = [
    pkg-config
    autoconf
    automake
  ];
  buildInputs = [
    openssl
    libgsf
    gmp
  ];

  # Avoid "-O5 -march=native"
  makeFlags = [ "OPTIM_FLAGS=" ];

  installPhase = ''
    mkdir -p $out/bin
    cp crackxls2003 $out/bin/
  '';

  meta = {
    homepage = "https://github.com/GavinSmith0123/crackxls2003/";
    description = "Used to break the encryption on old Microsoft Excel and Microsoft Word files";
    mainProgram = "crackxls2003";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.haylin ];
  };
})
