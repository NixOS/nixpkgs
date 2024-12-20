{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  openssl,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "libtpms";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "stefanberger";
    repo = "libtpms";
    rev = "v${version}";
    sha256 = "sha256-I2TYuOLwgEm6ofF2onWI7j2yu9wpXxNt7lJePSpF9VM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    perl # needed for pod2man
  ];
  buildInputs = [ openssl ];

  outputs = [
    "out"
    "man"
    "dev"
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-openssl"
    "--with-tpm2"
  ];

  meta = with lib; {
    description = "Libtpms library provides software emulation of a Trusted Platform Module (TPM 1.2 and TPM 2.0)";
    homepage = "https://github.com/stefanberger/libtpms";
    license = licenses.bsd3;
    maintainers = [ maintainers.baloo ];
  };
}
