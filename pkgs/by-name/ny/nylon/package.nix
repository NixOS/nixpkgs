{
  lib,
  stdenv,
  fetchurl,
  libevent,
  buildEnv,
}:
let
  # failed to find a better way to make it work
  libevent-comb = buildEnv {
    inherit (libevent.out) name;
    paths = [
      libevent.dev
      libevent.out
    ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nylon";
  version = "1.21";
  src = fetchurl {
    url = "https://monkey.org/~marius/nylon/nylon-${finalAttrs.version}.tar.gz";
    sha256 = "34c132b005c025c1a5079aae9210855c80f50dc51dde719298e1113ad73408a4";
  };

  patches = [ ./configure-use-solib.patch ];

  configureFlags = [ "--with-libevent=${libevent-comb}" ];

  buildInputs = [ libevent ];

  meta = {
    homepage = "http://monkey.org/~marius/nylon";
    description = "Proxy server, supporting SOCKS 4 and 5, as well as a mirror mode";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ edwtjo ];
    platforms = lib.platforms.linux;
    mainProgram = "nylon";
  };
})
