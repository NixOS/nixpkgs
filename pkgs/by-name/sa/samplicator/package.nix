{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "samplicator";
  version = "1.3.8rc1";

  nativeBuildInputs = [ autoreconfHook ];

  src = fetchFromGitHub {
    owner = "sleinen";
    repo = "samplicator";
    rev = finalAttrs.version;
    hash = "sha256-Ncf3Xb86WIz3bpQgNna2yeY0myFpTi52y9g0XhvdZTs=";
  };

  meta = {
    description = "Send copies of (UDP) datagrams to multiple receivers";
    homepage = "https://github.com/sleinen/samplicator/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "samplicate";
    platforms = lib.platforms.unix;
  };
})
