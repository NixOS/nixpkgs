{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libevent,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.60";
  pname = "ocproxy";

  src = fetchFromGitHub {
    owner = "cernekee";
    repo = "ocproxy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HbOpgxEMy2RcQi8hc19uuw3w+sGVALX5t8mTBa0dYgw=";
  };

  nativeBuildInputs = [
    autoconf
    automake
  ];
  buildInputs = [ libevent ];

  preConfigure = ''
    patchShebangs autogen.sh
    ./autogen.sh
  '';

  meta = {
    description = "OpenConnect proxy";
    longDescription = ''
      ocproxy is a user-level SOCKS and port forwarding proxy for OpenConnect
      based on lwIP.
    '';
    homepage = "https://github.com/cernekee/ocproxy";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.joko ];
    platforms = lib.platforms.unix;
  };
})
