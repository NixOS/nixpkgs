{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "vpcs";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = pname;
    rev = "v${version}";
    sha256 = "0kqy4bd3ns8nzn7fa72izn7a08sfrasy1rn7fd8ajah2wv8d2cak";
  };

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
    description = "A simple virtual PC simulator";
    longDescription = ''
      The VPCS (Virtual PC Simulator) can simulate up to 9 PCs. You can
      ping/traceroute them, or ping/traceroute the other hosts/routers from the
      VPCS when you study the Cisco routers in the dynamips.
    '';
    inherit (src.meta) homepage;
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
