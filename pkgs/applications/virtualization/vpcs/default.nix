{ stdenv, fetchurl, glibc }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "vpcs";
  version = "0.8";

  src = fetchurl {
    name = "${name}.tar.bz2";
    url = "mirror://sourceforge/project/${pname}/${version}/${name}-src.tbz";
    sha256 = "14y9nflcyq486vvw0na0fkfmg5dac004qb332v4m5a0vaz8059nw";
  };

  patches = [ ./vpcs-0.8-glibc-2.26.patch ];

  buildInputs = [ glibc.static ];

  buildPhase = ''(
    cd src
    ./mk.sh ${stdenv.buildPlatform.platform.kernelArch}
  )'';

  installPhase = ''
    install -D -m555 src/vpcs $out/bin/vpcs;
    install -D -m444 man/vpcs.1 $out/share/man/man1/vpcs.1;
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Virtual PC simulator";
    longDescription = ''
      The VPCS can simulate up to 9 PCs. You can ping/traceroute them, or
      ping/traceroute the other hosts/routers from the VPCS when you study the
      Cisco routers in the dynamips.
    '';
    homepage = "https://sourceforge.net/projects/vpcs/";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
