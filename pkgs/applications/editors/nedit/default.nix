{ stdenv, fetchurl, xlibsWrapper, motif, libXpm }:

stdenv.mkDerivation rec {
  pname = "nedit";
  version = "5.7";

  src = fetchurl {
    url = "mirror://sourceforge/nedit/nedit-source/${pname}-${version}-src.tar.gz";
    sha256 = "0ym1zhjx9976rf2z5nr7dj4mjkxcicimhs686snjhdcpzxwsrndd";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ xlibsWrapper ];
  buildInputs = [ motif libXpm ];

  # the linux config works fine on darwin too!
  buildFlags = stdenv.lib.optional (stdenv.isLinux || stdenv.isDarwin) "linux";

  NIX_CFLAGS_COMPILE="-DBUILD_UNTESTED_NEDIT -L${motif}/lib";

  installPhase = ''
    mkdir -p $out/bin
    cp -p source/nedit source/nc $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = "https://sourceforge.net/projects/nedit";
    description = "A fast, compact Motif/X11 plain text editor";
    platforms = with platforms; linux ++ darwin;
    license = licenses.gpl2;
  };
}
