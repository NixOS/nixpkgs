{ stdenv, fetchurl, qt4 }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "xkblayout-state";
  version = "1b";

  src = fetchurl {
    url = "https://github.com/nonpop/${pname}/archive/v${version}.tar.gz";
    sha256 = "1m1nnplrdb2mclhj0881wf78ckvdnyk24g4k4p5s5gpd96cxxwnx";
  };

  buildInputs = [ qt4 ];

  installPhase = ''
    mkdir -p $out/bin
    cp xkblayout-state $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A small command-line program to get/set the current XKB keyboard layout";
    homepage = https://github.com/nonpop/xkblayout-state;
    license = licenses.gpl2;
    maintainers = [ maintainers.jagajaga ];
    platforms = platforms.linux;
  };
}
