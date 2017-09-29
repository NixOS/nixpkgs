{ stdenv, fetchgit }:

stdenv.mkDerivation  {
  name = "win-pvdrivers-git-20150701";
  version = "20150701";

  src = fetchgit {
    url = "https://github.com/ts468/win-pvdrivers";
    rev = "3054d645fc3ee182bea3e97ff01869f01cc3637a";
    sha256 = "6232ca2b7c9af874abbcb9262faf2c74c819727ed2eb64599c790879df535106";
  };

  buildPhase =
    let unpack = x: "tar xf $src/${x}.tar; mkdir -p x86/${x} amd64/${x}; cp ${x}/x86/* x86/${x}/.; cp ${x}/x64/* amd64/${x}/.";
    in stdenv.lib.concatStringsSep "\n" (map unpack ["xenbus" "xeniface" "xenvif" "xennet" "xenvbd"]);

  installPhase = ''
    mkdir -p $out
    cp -r x86 $out/.
    cp -r amd64 $out/.
    '';

  meta = with stdenv.lib; {
    description = "Xen Subproject: Windows PV Driver";
    homepage = http://xenproject.org/downloads/windows-pv-drivers.html;
    maintainers = [ maintainers.tstrobel ];
    platforms = platforms.linux;
    license = licenses.bsd3;
  };
}
