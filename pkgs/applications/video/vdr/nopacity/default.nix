{ stdenv, lib, fetchFromGitLab, vdr, graphicsmagick }:
stdenv.mkDerivation rec {
  pname = "vdr-skin-nopacity";
  version = "1.1.14";

  src = fetchFromGitLab {
    repo = "SkinNopacity";
    owner = "kamel5";
    sha256 = "sha256-zSAnjBkFR8m+LXeoYO163VkNtVpfQZR5fI5CEzUABdQ=";
    rev = version;
  };

  buildInputs = [ vdr graphicsmagick ];

  installFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Highly customizable native true color skin for the Video Disc Recorder";
    maintainers = [ maintainers.ck3d ];
    license = licenses.gpl2;
    inherit (vdr.meta) platforms;
  };
}
