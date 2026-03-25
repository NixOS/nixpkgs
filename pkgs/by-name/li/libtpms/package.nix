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
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "stefanberger";
    repo = "libtpms";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-UhEpq5f/FT5DmtzQBe/Si414mOq+D4glikgRNK60GKQ=";
  };

  hardeningDisable = [ "strictflexarrays3" ];

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
