{ lib, stdenv
, fetchurl
, ladspaH
}:

stdenv.mkDerivation rec {
  pname = "cmt";
  version = "1.17";

  src = fetchurl {
    url = "http://www.ladspa.org/download/cmt_${version}.tgz";
    sha256 = "07xd0xmwpa0j12813jpf87fr9hwzihii5l35mp8ady7xxfmxfmpb";
  };

  buildInputs = [ ladspaH ];

  preBuild = ''
    cd src
  '';

  installFlags = [ "INSTALL_PLUGINS_DIR=${placeholder "out"}/lib/ladspa" ];
  preInstall = ''
    mkdir -p $out/lib/ladspa
  '';

  meta = with lib; {
    description = "Computer Music Toolkit";
    homepage = "https://www.ladspa.org/cmt";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ sjfloat ];
  };
}
