{ stdenv, fetchurl, xlibsWrapper, motif, libXpm }:

stdenv.mkDerivation rec {
  name = "nedit-${version}";
  version = "5.7";
  
  src = fetchurl {
    url = "mirror://sourceforge/nedit/nedit-source/${name}-src.tar.gz";
    sha256 = "0ym1zhjx9976rf2z5nr7dj4mjkxcicimhs686snjhdcpzxwsrndd";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ xlibsWrapper ];
  buildInputs = [ motif libXpm ];

  buildFlags = if stdenv.isLinux then "linux" else
               # the linux config works fine on darwin too!
               if stdenv.isDarwin then "linux" else "";

  NIX_CFLAGS_COMPILE="-DBUILD_UNTESTED_NEDIT -L${motif}/lib";

  installPhase = ''
    mkdir -p $out/bin
    cp -p source/nedit source/nc $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/projects/nedit;
    platforms = with platforms; linux ++ darwin;
    license = licenses.gpl2;
  };
}
