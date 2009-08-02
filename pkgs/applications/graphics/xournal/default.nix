a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "0.4.2.1" a; 
  buildInputs = with a; [
    ghostscript atk gtk glib fontconfig freetype
    libgnomecanvas libgnomeprint libgnomeprintui
    pango libX11 xproto zlib poppler popplerData
    autoconf automake libtool pkgconfig
  ];
in
rec {
  src = fetchurl {
    url = "http://downloads.sourceforge.net/xournal/xournal-${version}.tar.gz";
    sha256 = "1zxqcdhsd7h19c6pz7dwkr8bncn64v07liiqyw504m2v8lylrsif";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["setEnvVars" "doAutotools" "doConfigure" "doMakeInstall"];

  setEnvVars = a.noDepEntry (''
    export NIX_LDFLAGS="-lX11"
  '');
      
  name = "xournal-" + version;
  meta = {
    description = "note-taking application (supposes stylus)";
    maintainers = [
    ];
  };
}
