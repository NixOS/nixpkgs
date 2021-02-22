{ lib, stdenv, fetchFromGitHub, pkg-config
, ffmpeg_3, gtk3, imagemagick, libarchive, libspectre, libwebp, poppler
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
  buildInputs = [ ffmpeg_3 gtk3 imagemagick libarchive libspectre libwebp poppler ];

  prePatch = "patchShebangs .";

  meta = with lib; {
    description = "Powerful image viewer with minimal UI";
    homepage = "http://www.pberndt.com/Programme/Linux/pqiv";
    license = licenses.gpl3;
    maintainers = [];
    platforms = platforms.linux;
  };
})
