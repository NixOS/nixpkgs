{ lib, stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "omping";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner  = "troglobit";
    repo   = "omping";
    rev    = version;
    sha256 = "1f0vsbnhxp7bbgdnfqshryx3nhz2sqdnxdj068s0nmzsh53ckbf7";
  };

  patches = [
    # This can go in 0.0.6+
    (fetchpatch {
      url    = "https://github.com/troglobit/omping/commit/08a31ec1a6eb4e8f88c301ef679c3b6f9893f333.patch";
      sha256 = "1xafyvd46bq53w2zvjw8bdw7vjqbrcrr21cyh6d0zfcn4gif1k0f";
      name   = "fix_manpage_install.patch";
    })
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Open Multicast Ping (omping) is a tool for testing IPv4/IPv6 multicast connectivity on a LAN";
    license = licenses.mit;
    platforms = platforms.unix;
    inherit (src.meta) homepage;
    mainProgram = "omping";
  };
}
