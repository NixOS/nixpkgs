{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
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

  patches = [
    (fetchpatch2 {
      url = "https://github.com/stefanberger/libtpms/commit/2d9b00c4e42677cd0a9b67344f4d873ddc409a21.patch?full_index=1";
      hash = "sha256-MVHy0sdg8ywKzu9M4ueRjH786uXQK8al21k8f+mAdR0=";
    })
  ];

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
