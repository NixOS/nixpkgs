{ stdenv, fetchurl, lib }:

with lib;

stdenv.mkDerivation rec {
  pname = "Oracle_VM_VirtualBox_Extension_Pack";
  version = "6.0.12";

  src = fetchurl {
    url = "http://download.virtualbox.org/virtualbox/${version}/${pname}-${version}.vbox-extpack";
    sha256 = "0i74s6lcn8alksk3vvg4cbqdk5nlic3r55npyk60ljv581lrb817";
  };

  unpackCmd = ''
    mkdir -p out
    tar xf $curSrc -C out
  '';
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/${pname}
    cp -R * $out/${pname}
  '';

  meta = with stdenv.lib; {
    description = "Oracle Extension pack for VirtualBox";
    license = licenses.virtualbox-puel;
    homepage = https://www.virtualbox.org/;
    maintainers = with maintainers; [ flokli sander cdepillabout ];
    platforms = [ "x86_64-linux" ];
  };
}
