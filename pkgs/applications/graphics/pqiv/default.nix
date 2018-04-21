{ stdenv, fetchFromGitHub, pkgconfig
, ffmpeg, gtk3, imagemagick, libarchive, libspectre, libwebp, poppler
}:

stdenv.mkDerivation (rec {
  name = "pqiv-${version}";
  version = "2.10.3";

  src = fetchFromGitHub {
    owner = "phillipberndt";
    repo = "pqiv";
    rev = version;
    sha256 = "16nhnv0dcp242jf1099pjr5dwnc65i40cnb3dvx1avdhidcmsx01";
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
