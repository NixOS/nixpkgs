{ ctags, fetchurl, lib, libressl, ncurses, pkg-config, stdenv }:

stdenv.mkDerivation rec {
  pname = "catgirl";
  version = "2.1";

  src = fetchurl {
    url = "https://git.causal.agency/catgirl/snapshot/${pname}-${version}.tar.gz";
    sha256 = "sha256-pov7gvYlvN97xbem4VKP41Wbze1B8NPJcvi36Ri87o4=";
  };

  # catgirl's configure script uses pkg-config --variable exec_prefix openssl
  # to discover the install location of the openssl(1) utility. exec_prefix
  # is the "out" output of libressl in our case (where the libraries are
  # installed), so we need to fix this up.
  postConfigure = ''
    substituteInPlace config.mk --replace \
      "$($PKG_CONFIG --variable exec_prefix openssl)" \
      "${lib.getBin libressl}"
  '';

  nativeBuildInputs = [ ctags pkg-config ];
  buildInputs = [ libressl ncurses ];
  strictDeps = true;

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://git.causal.agency/catgirl/about/";
    license = licenses.gpl3Plus;
    description = "A TLS-only terminal IRC client";
    platforms = platforms.unix;
    maintainers = with maintainers; [ xfnw ];
  };
}
