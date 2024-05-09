{ stdenv, fetchurl, lib, virtualbox}:

let
  inherit (virtualbox) version;
in
stdenv.mkDerivation rec {
  pname = "VirtualBox-GuestAdditions-iso";
  inherit version;

  src = fetchurl {
    url = "http://download.virtualbox.org/virtualbox/${version}/VBoxGuestAdditions_${version}.iso";
    sha256 = "0efbcb9bf4722cb19292ae00eba29587432e918d3b1f70905deb70f7cf78e8ce";
  };

  buildCommand = ''
    mkdir -p $out
    cp $src $out/
  '';

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
