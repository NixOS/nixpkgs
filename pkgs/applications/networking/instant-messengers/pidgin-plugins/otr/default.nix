{ stdenv, fetchurl, libotr, pidgin} :

stdenv.mkDerivation {
  name = "pidgin-otr-3.1.0";
  src = fetchurl {
    url = http://www.cypherpunks.ca/otr/pidgin-otr-3.1.0.tar.gz;
    sha256 = "1l524qx5kh2gg68biazjyqiyz8qzxqwp07i0wzfaxgv33s9ni7s2";
  };

  meta = {
    description = "OTR plugin for Pidgin IM.";
  };

  buildInputs = [libotr pidgin];
}
