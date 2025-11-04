{
  pname,
  fetchurl,
  lib,
}:
rec {
  version = "4.3.7";
  inherit pname;

  src = fetchurl {
    url = "mirror://sourceforge/project/linux-gpib/linux-gpib%20for%203.x.x%20and%202.6.x%20kernels/${version}/linux-gpib-${version}.tar.gz";
    hash = "sha256-s/+BJgaGXIW1iwEqQhim/juC0XfIwKvHlcsi20HzrWg=";
  };

  unpackPhase = ''
    tar xf $src
    tar xf linux-gpib-${version}/${pname}-${version}.tar.gz
  '';

  sourceRoot = "${pname}-${version}";

  meta = with lib; {
    description = "Support package for GPIB (IEEE 488) hardware";
    homepage = "https://linux-gpib.sourceforge.io/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fsagbuya ];
    platforms = platforms.linux;
  };
}
