{ lib, stdenv, fetchFromGitHub, pkg-config
, ffmpeg, gtk3, imagemagick, libarchive, libspectre, libwebp, poppler
}:

stdenv.mkDerivation (rec {
  pname = "pqiv";
  version = "2.12";

  src = fetchFromGitHub {
    owner = "phillipberndt";
    repo = "pqiv";
    rev = version;
    sha256 = "18nvrqmlifh4m8nfs0d19sb9d1l3a95xc89qxqdr881jcxdsgflw";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ffmpeg gtk3 imagemagick libarchive libspectre libwebp poppler ];

  prePatch = "patchShebangs .";

  meta = with lib; {
    description = "Powerful image viewer with minimal UI";
    homepage = "https://www.pberndt.com/Programme/Linux/pqiv";
    license = licenses.gpl3Plus;
    maintainers = [];
    platforms = platforms.linux;
  };
})
