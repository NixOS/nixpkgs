{ stdenv, fetchFromGitHub, pkgconfig, libtool, autoconf, automake
, libjpeg, libexif
}:

stdenv.mkDerivation rec {
  pname = "epeg";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "mattes";
    repo = "epeg";
    rev = "v${version}";
    sha256 = "14bjl9v6zzac4df25gm3bkw3n0mza5iazazsi65gg3m6661x6c5g";
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
