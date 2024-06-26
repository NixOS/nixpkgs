{ pname, fetchurl, lib }: rec {
  version = "4.3.6";
  inherit pname;

  src = fetchurl {
    url = "mirror://sourceforge/project/linux-gpib/linux-gpib%20for%203.x.x%20and%202.6.x%20kernels/${version}/linux-gpib-${version}.tar.gz";
    hash = "sha256-Gze4xrvkhEgn+J5Jhrycezjp2uhlD1v6aX0WGv4J2Jg=";
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
