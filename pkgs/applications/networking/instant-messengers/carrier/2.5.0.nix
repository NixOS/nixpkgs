args : with args; 
/*
  arguments: all buildInputs
  optional: purple2Source: purple-2 source - place to copy libpurple from 
    (to use a fresher pidgin build)
*/
let 
  externalPurple2 = (lib.attrByPath ["purple2Source"] null args) != null; 
in
rec {
  src = fetchurl {
    url = http://downloads.sourceforge.net/funpidgin/carrier-2.5.0.tar.bz2;
    sha256 = "0m80s7hnvz5vc2dy3xiy1zfb6incmb7p28zahzxdif2vz44riz28";
  };

  buildInputs = [gtkspell aspell
    GStreamer startupnotification
    libxml2 openssl nss
    libXScrnSaver ncurses scrnsaverproto 
    libX11 xproto kbproto GConf avahi
    dbus dbus_glib glib python 
    autoconf libtool automake];

  propagatedBuildInputs = [
    pkgconfig gtk perl perlXMLParser gettext
  ];

  configureFlags="--with-nspr-includes=${nss}/include/nspr"
    + " --with-nspr-libs=${nss}/lib --with-nss-includes=${nss}/include/nss"
    + " --with-nss-libs=${nss}/lib --with-ncurses-headers=${ncurses}/include"
    + " --enable-screensaver --disable-meanwhile --disable-nm --disable-tcl";

  preBuild = fullDepEntry (''
    export echo=echo
  '') [];

  /* doConfigure should be specified separately */
  phaseNames = ["doConfigure" "preBuild" "doMakeInstall"]
    ++ (lib.optional externalPurple2 "postInstall")
  ;
      
  name = "carrier-2.5.0";
  meta = {
    description = "Carrier - PidginIM GUI fork with user-friendly development model";
    homepage = http://funpidgin.sf.net; 
  };
} // (if externalPurple2 then {
  postInstall = fullDepEntry (''
      ensureDir $out/lib/purple-2
      cp ${args.purple2Source}/lib/purple-2/* $out/lib/purple-2/
    '') ["minInit" "defEnsureDir"]; }
  else {})


