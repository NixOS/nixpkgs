{ lib, appimageTools, fetchurl }:

appimageTools.wrapType2 rec {
  pname = "xlights";
  version = "2024.09";

  src = fetchurl {
    url = "https://github.com/smeighan/xLights/releases/download/${version}/xLights-${version}-x86_64.AppImage";
    hash = "sha256-eXoSZUbwKu7174UVPguK9R0MgaMrV2jtRtLK/zSGvtw=";
  };

  meta = with lib; {
    description = "xLights is a sequencer for Lights. xLights has usb and E1.31 drivers. You can create sequences in this object oriented program. You can create playlists, schedule them, test your hardware, convert between different sequencers.";
    homepage = "https://xlights.org";
    license = licenses.gpl3;
    maintainers = with maintainers; [ kashw2 ];
    platforms = platforms.linux;
    mainProgram = "xlights-${version}";
  };
}
