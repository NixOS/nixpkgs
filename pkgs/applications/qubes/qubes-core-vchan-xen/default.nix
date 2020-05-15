{ stdenv, fetchFromGitHub, xen_4_10 }:

stdenv.mkDerivation rec {
  pname = "qubes-core-vchan-xen";
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "QubesOS";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wj4vv8nkzzig52r2nzkd4jy0cwznfkyddx379hfsdl4pzsp55mj";
  };

  buildInputs = [ xen_4_10 ];
  buildPhase = ''
    make all PREFIX=/
  '';
  installPhase = ''
    make install DESTDIR=$out PREFIX=/
  '';

  meta = with stdenv.lib; {
    description = "Libraries required for the higher-level Qubes daemons and tools";
    homepage = "https://qubes-os.org";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers."0x4A6F" ];
    platforms = platforms.linux;
  };
}

