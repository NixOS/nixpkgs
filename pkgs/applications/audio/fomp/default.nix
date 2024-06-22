{ lib, stdenv, fetchurl, lv2, pkg-config, python3, wafHook }:

stdenv.mkDerivation rec {
  pname = "fomp";
  version = "1.2.2";

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.bz2";
    sha256 = "sha256-xnGijydiO3B7BjSlryFuH1j/OPio9hCYbniq2IXp2W8=";
  };

  nativeBuildInputs = [ pkg-config wafHook ];
  buildInputs = [ lv2 python3 ];

  meta = with lib; {
    homepage = "https://drobilla.net/software/fomp.html";
    description = "LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
