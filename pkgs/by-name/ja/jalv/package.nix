{
  lib,
  stdenv,
  fetchurl,
  gtk2,
  libjack2,
  lilv,
  lv2,
  pkg-config,
  python3,
  serd,
  sord,
  sratom,
  suil,
  wafHook,
}:

stdenv.mkDerivation rec {
  pname = "jalv";
  version = "1.6.6";

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.bz2";
    sha256 = "sha256-ktFBeBtmQ3MgfDQ868XpuM7UYfryb9zLld8AB7BjnhY=";
  };

  nativeBuildInputs = [
    pkg-config
    wafHook
  ];
  buildInputs = [
    gtk2
    libjack2
    lilv
    lv2
    python3
    serd
    sord
    sratom
    suil
  ];

  meta = with lib; {
    description = "Simple but fully featured LV2 host for Jack";
    homepage = "http://drobilla.net/software/jalv";
    license = licenses.isc;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
