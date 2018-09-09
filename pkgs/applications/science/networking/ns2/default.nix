{ stdenv, fetchurl, autoconf, tk, tcl, otcl, tclcl, xlibs, libpcap, perl }:
stdenv.mkDerivation rec {
  version = "2.35";

  name = "ns2-${version}";

  src = fetchurl {
    url = "http://sourceforge.net/projects/nsnam/files/ns-2/${version}/ns-src-${version}.tar.gz";
    sha256 = "11r35q8w3v8wi0q3s3kdd5kswpnib5smfi558982azgcphqyhcia";
  };
      
  patches = map fetchurl (import ./debian-patches.nix);

  postPatch = ''
    substituteInPlace conf/configure.in.tk \
      --replace 'TK_H_PLACES_D="$d' 'TK_H_PLACES_D="${tk.dev}/include'
  '';

  # running full autoreconf breaks an existing autoconf.h.in 
  preConfigure = ''
    ${autoconf}/bin/autoconf -f
  '';

  configureFlags = [
    "--with-tcl=${tcl}"
    "--with-tcl-ver=${tcl.release}"
    "--with-tk=${tk}"
    "--with-tk-ver=${tk.release}"
    "--with-otcl=${otcl}"
    "--with-tclcl=${tclcl}"
  ];

  nativeBuildInputs = [ 
    perl 
    libpcap
    xlibs.libX11 xlibs.libXt xlibs.libXext 
    ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  postInstall = ''
     install -t $out/bin nse nstk
  '';

  meta = with stdenv.lib; {
    description = "A discrete event simulator targeted at networking research";
    homepage = https://www.isi.edu/nsnam/ns/;
    license = with licenses; [ bsdOriginal bsd3 asl20 gpl2 ];
    maintainers = [ maintainers.pschuprikov ];
    platforms = platforms.unix;
  };
}
