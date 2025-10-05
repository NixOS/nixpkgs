{
  fetchurl,
  lib,
  virtualboxVersion,
}:
fetchurl {
  url = "http://download.virtualbox.org/virtualbox/${virtualboxVersion}/VBoxGuestAdditions_${virtualboxVersion}.iso";
  sha256 = "43f7a1045cad0aab40e3af906fea37244ba6873b91b4e227245a14e51b399abd";
  meta = {
    description = "Guest additions ISO for VirtualBox";
    longDescription = ''
      ISO containing various add-ons which improves guests inside VirtualBox.
    '';
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.gpl2;
    maintainers = [
      lib.maintainers.sander
      lib.maintainers.friedrichaltheide
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
