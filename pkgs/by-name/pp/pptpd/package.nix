{
  lib,
  stdenv,
  fetchurl,
  ppp,
}:

stdenv.mkDerivation rec {
  pname = "pptpd";
  version = "1.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/poptop/${pname}/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "1h06gyxj51ba6kbbnf6hyivwjia0i6gsmjz8kyggaany8a58pkcg";
  };

  patches = [
    ./ppp-2.5.0-compat.patch
  ];

  buildInputs = [ ppp ];

  postPatch = ''
    substituteInPlace plugins/Makefile --replace "install -o root" "install"
  '';

  meta = {
    homepage = "https://poptop.sourceforge.net/dox/";
    description = "PPTP Server for Linux";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ obadz ];
    license = lib.licenses.gpl2Only;
  };
}
