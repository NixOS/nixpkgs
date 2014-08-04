{ stdenv, fetchurl, libotr, pidgin, intltool } :

stdenv.mkDerivation rec {
  name = "pidgin-otr-4.0.0";
  src = fetchurl {
    url = "http://www.cypherpunks.ca/otr/${name}.tar.gz";
    sha256 = "14a6vxvlkm8wazng9aj7p82dr12857fx5is1frcyd7my5l4kysym";
  };

  postInstall = "ln -s \$out/lib/pidgin \$out/share/pidgin-otr";

  buildInputs = [ libotr pidgin intltool ];

  meta = {
    homepage = http://www.cypherpunks.ca/otr;
    description = "Plugin for Pidgin 2.x which implements OTR Messaging";
    license = stdenv.lib.licenses.gpl2;
  };
}
