{ stdenv, fetchFromGitHub, pkgconfig, libtool, autoconf, automake
, libjpeg, libexif
}:

stdenv.mkDerivation rec {
  name = "epeg-0.9.1.042"; # version taken from configure.ac

  src = fetchFromGitHub {
    owner = "mattes";
    repo = "epeg";
    rev = "248ae9fc3f1d6d06e6062a1f7bf5df77d4f7de9b";
    sha256 = "14ad33w3pxrg2yfc2xzyvwyvjirwy2d00889dswisq8b84cmxfia";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig libtool autoconf automake ];

  propagatedBuildInputs = [ libjpeg libexif ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/mattes/epeg;
    description = "Insanely fast JPEG/ JPG thumbnail scaling";
    platforms = platforms.linux ++ platforms.darwin;
    license = {
      url = "https://github.com/mattes/epeg#license";
    };
    maintainers = with maintainers; [ nh2 ];
  };
}
