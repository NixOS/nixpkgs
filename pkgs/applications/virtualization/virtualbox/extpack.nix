{stdenv, fetchurl, lib}:

with lib;

let version = "5.2.22";
in
fetchurl rec {
  name = "Oracle_VM_VirtualBox_Extension_Pack-${version}.vbox-extpack";
  url = "https://download.virtualbox.org/virtualbox/${version}/${name}";
  sha256 = "1vria59m7xr521hp2sakfihv8282xcfd5hl6dr1gbcjicmk514kp";

  meta = {
    description = "Oracle Extension pack for VirtualBox";
    license = licenses.virtualbox-puel;
    homepage = https://www.virtualbox.org/;
    maintainers = with maintainers; [ flokli sander cdepillabout ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
