{ fetchurl, lib, virtualbox}:

let
  inherit (virtualbox) version;
in
fetchurl {
  url = "http://download.virtualbox.org/virtualbox/${version}/VBoxGuestAdditions_${version}.iso";
  sha256 = "486f90cbfe9ed4bf2b12d726ebf54a839758a237e967aa65fc2c92d90a963021";
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
