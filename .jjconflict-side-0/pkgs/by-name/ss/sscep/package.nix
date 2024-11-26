{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  openssl,
  autoreconfHook,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sscep";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "certnanny";
    repo = "sscep";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wlxQONOCLPuNdI6AyMJoLP09cs+ak7Jv9idhXTT5RWA=";
  };

  buildInputs = [ openssl ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Client-only implementation of the SCEP (Cisco System's Simple Certificate Enrollment Protocol)";
    homepage = "https://github.com/certnanny/sscep";
    maintainers = [ lib.maintainers.stv0g ];
    license = [
      lib.licenses.bsd2
      lib.licenses.openssl
    ];
    platforms = lib.platforms.all;
  };
})
