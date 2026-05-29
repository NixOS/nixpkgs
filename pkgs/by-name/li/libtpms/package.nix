{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  openssl,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtpms";
  version = "0.10.2-unstable-2026-05-06";

  src = fetchFromGitHub {
    owner = "stefanberger";
    repo = "libtpms";
    rev = "521c51073fe6f7c56023db78e56961fcaf7906e8";
    hash = "sha256-wCipOOr3LnLq1NqDtxw6hq0VTyniDwp18vBxyET/WGM=";
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

  meta = {
    description = "Library for software emulation of a Trusted Platform Module (TPM 1.2 and TPM 2.0)";
    homepage = "https://github.com/stefanberger/libtpms";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.baloo ];
  };
})
