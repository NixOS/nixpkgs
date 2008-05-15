args : with args; 
rec {
  src = fetchurl {
    url = http://downloads.sourceforge.net/funpidgin/funpidgin-2.4.1.tar.bz2;
    sha256 = "1slzvgwaxl19fdyg7k12nqsvvbjaqv6ivfzwkbvm09596ag5r3mn";
  };

  buildInputs = [gtkspell aspell
    GStreamer startupnotification
    libxml2 openssl nss
    libXScrnSaver ncurses scrnsaverproto 
    libX11 xproto];

  propagatedBuildInputs = [
    pkgconfig gtk perl perlXMLParser gettext
  ];

  configureFlags="--with-nspr-includes=${nss}/include/nspr --with-nspr-libs=${nss}/lib --with-nss-includes=${nss}/include/nss --with-nss-libs=${nss}/lib --with-ncurses-headers=${ncurses}/include --enable-screensaver";

  /* doConfigure should be specified separately */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  name = "funpidgin-" + version;
  meta = {
    description = "Funpidgin - PidginIM fork with user-friendly development model";
    homepage = http://funpidgin.sf.net; 
  };
}

