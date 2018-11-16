{ stdenv, fetchurl, dpkg, bash, python27Packages }:

let
  py = python27Packages;
in
stdenv.mkDerivation rec {
  name = "cura-lulzbot-${version}";
  version = "15.02.1-1.03-5064";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://download.alephobjects.com/ao/aodeb/dists/jessie/main/binary-amd64/cura_${version}_amd64.deb";
        sha256 = "1gsfidg3gim5pjbl82vkh0cw4ya253m4p7nirm8nr6yjrsirkzxg";
      }
    else if stdenv.hostPlatform.system == "i686-linux" then
      fetchurl {
        url = "http://download.alephobjects.com/ao/aodeb/dists/jessie/main/binary-i386/cura_${version}_i386.deb";
        sha256 = "0xd3df6bxq4rijgvsqvps454jkc1nzhxbdzzj6j2w317ppsbhyc1";
      }
    else throw "${name} is not supported on ${stdenv.hostPlatform.system}";

  python_deps = with py; [ pyopengl pyserial numpy wxPython30 power setuptools ];
  pythonPath = python_deps;
  propagatedBuildInputs = python_deps;
  buildInputs = [ dpkg bash py.wrapPython ];

  phases = [ "unpackPhase" "installPhase" ];
  unpackPhase = "dpkg-deb -x ${src} ./";

  installPhase = ''
    mkdir -p $out/bin
    cp -r usr/share $out/share
    find $out/share -type f -exec sed -i 's|/usr/share/cura|$out/share/cura|g' "{}" \;

    cat <<EOT > $out/bin/cura
    #!${bash}/bin/bash
    PYTHONPATH=$PYTHONPATH:$out/share/cura ${py.python}/bin/python $out/share/cura/cura.py "\$@"
    EOT

    chmod 555 $out/bin/cura
  '';

  meta = with stdenv.lib; {
    description = "3D printing host software for the Lulzbot";

     longDescription = ''
       Cura LulzBot Edition is a fork of the 3D printing/slicing
       software from Ultimaker, with changes to support 3D printers
       from Aleph Objects.
     '';

    homepage = https://www.lulzbot.com/cura/;
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pjones ];
  };
}
