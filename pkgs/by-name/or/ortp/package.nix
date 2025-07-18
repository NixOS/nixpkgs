{
  bctoolbox,
  cmake,
  fetchFromGitLab,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ortp";
  version = "5.3.72";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = "ortp";
    rev = finalAttrs.version;
    hash = "sha256-xItIVweRenH9uSCg9E9BRG2uxem9wY8cKoJwBqHcBMo=";
  };

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=stringop-truncation";

  buildInputs = [ bctoolbox ];
  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Real-Time Transport Protocol (RFC3550) stack. Part of the Linphone project";
    mainProgram = "ortp_tester";
    homepage = "https://linphone.org/technical-corner/ortp";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
})
