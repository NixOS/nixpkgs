{ fetchFromGitHub
, autoconf
, automake
, stdenv
, intltool
, pkgconfig
, gtk3
, xdotool
, hicolor-icon-theme
, libappindicator-gtk3
}:

stdenv.mkDerivation rec {
  name = "clipit-${version}";
  version = "50d983514386029a1f133187902084b753458f32";

  src = fetchFromGitHub {
    owner = "IvanMalison";
    repo = "ClipIt";
    rev = version;
    sha256 = "1d52zjnxmcp2kr4wvq2yn9fhr61v9scp91fxfvasvz5m7k1zagdn";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
      autoconf automake intltool gtk3 xdotool hicolor-icon-theme
      libappindicator-gtk3
    ];

  preConfigure = "./autogen.sh";
  configureFlags = ["--with-gtk3" "--enable-appindicator"];
  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  meta = with stdenv.lib; {
    description = "Lightweight GTK+ Clipboard Manager";
    homepage    = "http://clipit.rspwn.com";
    maintainers = with stdenv.lib.maintainers; [ imalison ];
    license     = licenses.gpl3;
    platforms   = platforms.linux;
  };
}
