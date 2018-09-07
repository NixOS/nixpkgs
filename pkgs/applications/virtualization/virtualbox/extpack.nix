{stdenv, fetchurl, lib}:

with lib;

let extpackRev = "123301";
    version = "5.2.14";
in
fetchurl rec {
  name = "Oracle_VM_VirtualBox_Extension_Pack-${version}-${toString extpackRev}.vbox-extpack";
  url = "http://download.virtualbox.org/virtualbox/${version}/${name}";
  sha256 = "d90c1b0c89de19010f7c7fe7a675ac744067baf29a9966b034e97b5b2053b37e";

  meta = {
    description = "Oracle Extension pack for VirtualBox";
    license = licenses.virtualbox-puel;
    homepage = https://www.virtualbox.org/;
    maintainers = with maintainers; [ flokli sander cdepillabout ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
