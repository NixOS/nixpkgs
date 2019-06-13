{ stdenv, fetchFromGitHub, pkgconfig
, ffmpeg, gtk3, imagemagick, libarchive, libspectre, libwebp, poppler
}:

stdenv.mkDerivation (rec {
  name = "pqiv-${version}";
  version = "2.11";

  src = fetchFromGitHub {
    owner = "phillipberndt";
    repo = "pqiv";
    rev = version;
    sha256 = "06cwm28b7j1skwp21s5snmj1pqh3xh6y2i5v4w3pz0b8k3053h9i";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ffmpeg gtk3 imagemagick libarchive libspectre libwebp poppler ];

  prePatch = "patchShebangs .";

  meta = with stdenv.lib; {
    description = "Powerful image viewer with minimal UI";
    homepage = http://www.pberndt.com/Programme/Linux/pqiv;
    license = licenses.gpl3;
    maintainers = [ maintainers.ndowens ];
    platforms = platforms.linux;
  };
})
