{ fetchurl, lib, virtualbox}:

let
  inherit (virtualbox) version;
in
fetchurl {
  url = "http://download.virtualbox.org/virtualbox/${version}/VBoxGuestAdditions_${version}.iso";
  sha256 = "4469bab0f59c62312b0a1b67dcf9c07a8a971afad339fa2c3eb80e209e099ef9";
  meta = {
    description = "Guest additions ISO for VirtualBox";
    longDescription = ''
      ISO containing various add-ons which improves guests inside VirtualBox.
    '';
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.sander lib.maintainers.friedrichaltheide ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
