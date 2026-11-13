{
  lib,
  stdenv,
  fetchurl,
  libxcrypt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "srelay";
  version = "0.4.9";

  src = fetchurl {
    url = "mirror://sourceforge/project/socks-relay/socks-relay/srelay-${finalAttrs.version}/srelay-${finalAttrs.version}.tar.gz";
    hash = "sha256-nbxbLPpc1Mty2NaECEKZN8gAp809XaNeizFb9phNLtw=";
  };

  buildInputs = [ libxcrypt ];

  # upstream declares signal handlers with unprototyped function pointers, which the C23 default of recent GCC rejects
  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

  installPhase = "install -D srelay $out/bin/srelay";

  meta = {
    description = "SOCKS proxy and relay";
    homepage = "http://socks-relay.sourceforge.net/";
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd3;
    # never built on aarch64-linux since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64;
    mainProgram = "srelay";
    maintainers = with lib.maintainers; [ enovamaker ];
  };
})
