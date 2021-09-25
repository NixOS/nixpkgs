{ fetchFromSourcehut, gtk3, lib, libdbusmenu-gtk3, pkg-config, stdenv, vala }:

stdenv.mkDerivation rec {
  pname = "snixembed";
  version = "0.3.1";

  src = fetchFromSourcehut {
    owner = "~steef";
    repo = pname;
    rev = version;
    sha256 = "0yy1i4463q43aq98qk4nvvzpw4i6bid2bywwgf6iq545pr3glfj5";
  };

  nativeBuildInputs = [ pkg-config vala ];

  buildInputs = [ gtk3 libdbusmenu-gtk3 ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Proxy StatusNotifierItems as XEmbedded systemtray-spec icons";
    homepage = "https://git.sr.ht/~steef/snixembed";
    changelog = "https://git.sr.ht/~steef/snixembed/refs/${version}";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ figsoda ];
  };
}
