{ stdenv, fetchurl, pkgconfig, libXt }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "xscope";
  version = "1.4.1";

  src = fetchurl {
    url = "mirror://xorg/individual/app/${name}.tar.bz2";
    sha256 = "08zl3zghvbcqy0r5dn54dim84lp52s0ygrr87jr3a942a6ypz01k";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libXt ];

  meta = with stdenv.lib; {
    description = "program to monitor X11/Client conversations";
    homepage = https://cgit.freedesktop.org/xorg/app/xscope/;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ];
    platforms = with platforms; unix;
  };
}

