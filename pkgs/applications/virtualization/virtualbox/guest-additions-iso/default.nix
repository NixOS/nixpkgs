{
  fetchurl,
  lib,
  virtualboxVersion,
}:
fetchurl {
  url = "http://download.virtualbox.org/virtualbox/${virtualboxVersion}/VBoxGuestAdditions_${virtualboxVersion}.iso";
  sha256 = "fc41354d8b974051fa33ca5a4f9c999a58c6e0dfc595b02a924a544392234b3d";
  meta = {
    description = "Guest additions ISO for VirtualBox";
    longDescription = ''
      ISO containing various add-ons which improves guests inside VirtualBox.
    '';
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.gpl2;
    maintainers = [
      lib.maintainers.friedrichaltheide
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
