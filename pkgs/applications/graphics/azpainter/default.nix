{ stdenv, fetchFromGitHub, autoreconfHook
, libX11, libXext, libXi
, freetype, fontconfig
, libpng, libjpeg
, zlib
}:

stdenv.mkDerivation rec {
  pname = "azpainter";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "Symbian9";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "0x5jmsprjissqcvwq75pqq9wgv4k9b7cy507hai8xk6xs3vxwgba";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    libX11 libXext libXi
    freetype fontconfig
    libpng libjpeg
    zlib
  ];

  configureFlags = [
    "--with-freetype-dir=${stdenv.lib.getDev freetype}/include/freetype2"
  ];

  meta = with stdenv.lib; {
    description = "Full color painting software for illustration drawing";
    homepage = "https://osdn.net/projects/azpainter";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dtzWill ];
  };
}
