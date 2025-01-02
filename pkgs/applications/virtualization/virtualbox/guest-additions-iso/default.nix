{
  fetchurl,
  lib,
  virtualbox,
}:

let
  inherit (virtualbox) version;
in
fetchurl {
  url = "http://download.virtualbox.org/virtualbox/${version}/VBoxGuestAdditions_${version}.iso";
  sha256 = "80c91d35742f68217cf47b13e5b50d53f54c22c485bacce41ad7fdc321649e61";
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
