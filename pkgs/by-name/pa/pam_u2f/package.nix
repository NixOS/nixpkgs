{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libfido2,
  pam,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "pam_u2f";
  version = "1.3.1";

  src = fetchurl {
    url = "https://developers.yubico.com/pam-u2f/Releases/${pname}-${version}.tar.gz";
    hash = "sha256-mhNUmUf4RPazq2kdca+09vAKRdFl/tJ7AcZsB3UKk4c=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libfido2
    pam
    openssl
  ];

  preConfigure = ''
    configureFlagsArray+=("--with-pam-dir=$out/lib/security")
  '';

  # a no-op makefile to prevent building the fuzz targets
  postConfigure = ''
    cat > fuzz/Makefile <<EOF
    all:
    install:
    EOF
  '';

  meta = with lib; {
    homepage = "https://developers.yubico.com/pam-u2f/";
    description = "PAM module for allowing authentication with a U2F device";
    changelog = "https://github.com/Yubico/pam-u2f/raw/pam_u2f-${version}/NEWS";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ philandstuff ];
    mainProgram = "pamu2fcfg";
  };
}
