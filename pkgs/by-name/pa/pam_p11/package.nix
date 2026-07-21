{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libp11,
  pam,
  libintl,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pam_p11";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "pam_p11";
    rev = "pam_p11-${finalAttrs.version}";
    hash = "sha256-BYpZM+j0F5qtbkNdAk2qAczGTBlXe87FLBzKwp7fw7U=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    pam
    libp11.passthru.openssl
    libp11
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ libintl ];

  meta = {
    homepage = "https://github.com/OpenSC/pam_p11";
    description = "Authentication with PKCS#11 modules";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sb0 ];
  };
})
