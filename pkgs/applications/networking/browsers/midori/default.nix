args :  
let 
  lib = args.lib;
  fetchurl = args.fetchurl;
  doPatchShebangs = args.doPatchShebangs;
  makeManyWrappers = args.makeManyWrappers;

  version = "0.4"; 
  release = "4";
  buildInputs = with args; [
    intltool python imagemagick gtk3 glib webkit libxml2 
    gtksourceview pkgconfig which gettext makeWrapper 
    file libidn sqlite docutils libnotify libsoup vala
    kbproto xproto scrnsaverproto libXScrnSaver dbus_glib
  ];
in
rec {
  src = fetchurl {
    url = "http://archive.xfce.org/src/apps/midori/${version}/midori-${version}.${release}.tar.bz2";
    sha256 = "fadd43f76c1c9f6a16483e60a804e58fb6817c6a595b1acdd59bcbdd7b35bca2";
  };

  inherit buildInputs;
  configureFlags = ["--enable-gtk3"];

  /* doConfigure should be specified separately */
  phaseNames = ["doUnpack" "setVars" "shebangsHere" "doConfigure" 
    "doMakeInstall" "shebangsInstalled" "wrapWK"
    ];

  setVars = args.fullDepEntry ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lnotify"
  '' [];
      
  shebangsHere = (doPatchShebangs ".");
  shebangsInstalled = (doPatchShebangs "$out/bin");
  wrapWK = (makeManyWrappers "$out/bin/*" "--set WEBKIT_IGNORE_SSL_ERRORS 1");

  name = "midori-${version}.${release}";
  meta = {
    description = "Light WebKit-based web browser with GTK GUI.";
    maintainers = [args.lib.maintainers.raskin];
    platforms = with args.lib.platforms;
      linux;
  };
}
