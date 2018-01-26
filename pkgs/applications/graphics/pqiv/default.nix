{ stdenv, fetchFromGitHub, pkgconfig
, ffmpeg, gtk3, imagemagick, libarchive, libspectre, libwebp, poppler
}:

stdenv.mkDerivation (rec {
  name = "pqiv-${version}";
  version = "2.10.2";

  src = fetchFromGitHub {
    owner = "phillipberndt";
    repo = "pqiv";
    rev = version;
    sha256 = "0zn7ps73lw04l9i4777c90ik07v3hkg66mnpz8vvvwjyi40i77a7";
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
