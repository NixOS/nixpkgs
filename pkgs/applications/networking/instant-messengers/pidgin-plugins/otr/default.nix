{ stdenv, fetchurl, libotr, pidgin} :

stdenv.mkDerivation {
  name = "pidgin-otr-3.2.0";
  src = fetchurl {
    url = http://www.cypherpunks.ca/otr/pidgin-otr-3.2.0.tar.gz;
    sha256 = "1cp6s565sid657lvmm7jrwl9wnk4ywsl8d9sp4iba36r0s5qaw08";
  };

  meta = {
    description = "OTR plugin for Pidgin IM.";
    homepage = http://www.cypherpunks.ca/otr;
  };

  postInstall = "ln -s \$out/lib/pidgin \$out/share/pidgin-otr";

  buildInputs = [libotr pidgin];
}
