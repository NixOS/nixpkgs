{
  fetchurl,
  lib,
  virtualboxVersion,
}:
fetchurl {
  url = "http://download.virtualbox.org/virtualbox/${virtualboxVersion}/VBoxGuestAdditions_${virtualboxVersion}.iso";
  sha256 = "4f51a073296de31cce53924860549149be5dc339f65dcd1dbf34fd7accefe8fb";
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
