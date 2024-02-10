{ stdenv, lib, fetchFromGitLab, vdr, graphicsmagick }:
stdenv.mkDerivation rec {
  pname = "vdr-skin-nopacity";
  version = "1.1.16";

  src = fetchFromGitLab {
    repo = "SkinNopacity";
    owner = "kamel5";
    sha256 = "sha256-5TTilBKlNsFBm5BaCoRV1LzZgpad2lOIQGyk94jGYls=";
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
