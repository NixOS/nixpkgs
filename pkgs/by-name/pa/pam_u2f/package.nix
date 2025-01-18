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
  version = "1.3.2";

  src = fetchurl {
    url = "https://developers.yubico.com/pam-u2f/Releases/${pname}-${version}.tar.gz";
    hash = "sha256-OL59GJcnHLP+45HSODs1r8EmrUMakanebpkQjBLMlJA=";
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
