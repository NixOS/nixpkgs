{ fetchgit, stdenv, lib, autoreconfHook, pkg-config, libnpupnp, curl, expat }:

stdenv.mkDerivation rec {
  pname = "libupnpp";
  version = "1.0.3";

  src = fetchgit {
    url = "https://framagit.org/medoc92/libupnpp.git";
    rev = "libupnpp-v${version}";
    sha256 = "sha256-duLmy9Vxh6/IAo/mZlX/VbqFQaXTpgN3nYFUMSn784E=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config libnpupnp curl expat ];

  meta = {
    description = "higher level C++ API over libnpupnp or libupnp";

    license = "BSD-style";

    homepage = https://framagit.org/medoc92/npupnp;
    platforms = lib.platforms.unix;
  };
}
