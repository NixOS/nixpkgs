{ stdenv
, fetchFromGitHub
, xen_4_10
}:

stdenv.mkDerivation rec {
  pname = "qubes-core-vchan-xen";
  version = "4.1.4";

  src = fetchFromGitHub {
    owner = "QubesOS";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256:02l1vs5c2jfw22gxvl2fb66m0d99n8ya1i7rphsb5cxsljvxary0";
  };

  buildInputs = [ xen_4_10 ];

  buildPhase = ''
    make all PREFIX=/ LIBDIR="$out/lib" INCLUDEDIR="$out/include"
  '';

  installPhase = ''
    make install DESTDIR=$out PREFIX=/
  '';

  meta = with stdenv.lib; {
    description = "Libraries required for the higher-level Qubes daemons and tools";
    homepage = "https://qubes-os.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ _0x4A6F ];
    platforms = platforms.linux;
  };

}
