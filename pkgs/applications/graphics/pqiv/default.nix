{ stdenv, fetchFromGitHub, pkgconfig
, ffmpeg, gtk3, imagemagick, libarchive, libspectre, libwebp, poppler
}:

stdenv.mkDerivation (rec {
  name = "pqiv-${version}";
  version = "2.10.4";

  src = fetchFromGitHub {
    owner = "phillipberndt";
    repo = "pqiv";
    rev = version;
    sha256 = "04fawc3sd625y1bbgfgwmak56pq28sm58dwn5db4h183iy3awdl9";
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
