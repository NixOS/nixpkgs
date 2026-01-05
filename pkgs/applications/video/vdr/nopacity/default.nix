{
  stdenv,
  lib,
  fetchFromGitLab,
  vdr,
  graphicsmagick,
}:
stdenv.mkDerivation rec {
  pname = "vdr-skin-nopacity";
  version = "1.1.19";

  src = fetchFromGitLab {
    repo = "SkinNopacity";
    owner = "kamel5";
    hash = "sha256-f15KtoPLvB5bF//5+gmmDmx8MGmiIDPGOYoNgSkcVqM=";
    tag = version;
  };

  buildInputs = [
    vdr
    graphicsmagick
  ];

  installFlags = [ "DESTDIR=$(out)" ];

  meta = {
    inherit (src.meta) homepage;
    description = "Highly customizable native true color skin for the Video Disc Recorder";
    maintainers = [ lib.maintainers.ck3d ];
    license = lib.licenses.gpl2;
    inherit (vdr.meta) platforms;
  };
}
