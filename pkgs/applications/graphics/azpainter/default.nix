{ stdenv, fetchFromGitHub
, libX11, libXext, libXi
, freetype, fontconfig
, libpng, libjpeg
, zlib
}:

stdenv.mkDerivation rec {
  pname = "azpainter";
  version = "2.1.6";

  src = fetchFromGitHub {
    owner = "Symbian9";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-al87Rnf4HkKdmtN3EqxC0zEHgVWwnVi7WttqT/Qxr0Q=";
  };

  buildInputs = [
    libX11 libXext libXi
    freetype fontconfig
    libpng libjpeg
    zlib
  ];

  meta = with stdenv.lib; {
    description = "Full color painting software for illustration drawing";
    homepage = "https://osdn.net/projects/azpainter";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dtzWill ];
    platforms = with platforms; linux ++ darwin;
  };
}
