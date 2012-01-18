{stdenv, fetchurl, pkgconfig, browser, libXpm, gettext}:

stdenv.mkDerivation rec {
  name = "mplayerplug-in-3.55";

  src = fetchurl {
    url = "mirror://sourceforge/mplayerplug-in/${name}.tar.gz";
    sha256 = "0zkvqrzibrbljiccvz3rhbmgifxadlrfjylqpz48jnjx9kggynms";
  };

  patches =
    stdenv.lib.optional (browser ? isFirefox3Like) ./icecat3-idldir.patch;

  postConfigure =
    (if browser ? isFirefox3Like then ''
       # Cause a rebuild of these file from the IDL file, needed for GNU IceCat 3
       # and Mozilla Firefox 3.
       # See, e.g., http://article.gmane.org/gmane.comp.mozilla.mplayerplug-in/2104 .
       rm -f Source/nsIScriptableMplayerPlugin.h
     ''
     else "");

  buildInputs = [ pkgconfig browser (browser.gtk) libXpm gettext ];
  
  installPhase = ''
    mkdir -p $out/lib/mozilla/plugins
    cp -p mplayerplug-in*.so mplayerplug-in*.xpt $out/lib/mozilla/plugins
  '';

  passthru = {
    mozillaPlugin = "/lib/mozilla/plugins";
  };

  meta = {
    description = "A browser plugin that uses mplayer to play digital media from websites";
    homepage = http://mplayerplug-in.sourceforge.net/;
    licenses = [ "GPLv2+" "LGPLv2+" "MPLv1+" ];
  };
}
