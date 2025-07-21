{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libfido2,
  pam,
  openssl,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "pam_u2f";
  version = "1.4.0";

  src = fetchurl {
    url = "https://developers.yubico.com/pam-u2f/Releases/${pname}-${version}.tar.gz";
    hash = "sha256-pZknzqOOqNkaaDagTiD8Yp7d5CBLFggvcD9ts3jpxjQ=";
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

  passthru.tests = {
    pam_u2f = nixosTests.pam-u2f;
  };

  meta = {
    homepage = "https://developers.yubico.com/pam-u2f/";
    description = "PAM module for allowing authentication with a U2F device";
    changelog = "https://github.com/Yubico/pam-u2f/raw/pam_u2f-${version}/NEWS";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ philandstuff ];
    mainProgram = "pamu2fcfg";
  };
}
