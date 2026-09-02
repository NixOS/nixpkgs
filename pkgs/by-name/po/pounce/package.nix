{
  lib,
  stdenv,
  libretls,
  openssl,
  fetchzip,
  pkg-config,
  libxcrypt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pounce";
  version = "3.2";

  src = fetchzip {
    url = "https://git.causal.agency/pounce/snapshot/pounce-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-7FAB5kNOg465x8MFTyndJD4pqxJ6Wu3av+CbXGZuxWA=";
  };

  buildInputs = [
    libretls
    openssl
    libxcrypt
  ];

  nativeBuildInputs = [ pkg-config ];

  buildFlags = [ "all" ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = {
    homepage = "https://code.causal.agency/june/pounce";
    description = "Simple multi-client TLS-only IRC bouncer";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ edef ];
  };
})
