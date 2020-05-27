{ fetchFromGitHub, fetchpatch, stdenv
, autoreconfHook, intltool, pkgconfig
, gtk3, xdotool, which, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "clipit";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "CristianHenzel";
    repo = "ClipIt";
    rev = "45e2ea386d04dbfc411ea370299502450d589d0c";
    sha256 = "0byqz9hanwmdc7i55xszdby2iqrk93lws7hmjda2kv17g34apwl7";
  };

  preConfigure = ''
    intltoolize --copy --force --automake
  '';

  nativeBuildInputs = [ pkgconfig wrapGAppsHook autoreconfHook intltool ];
  configureFlags = [ "--with-gtk3" ];
  buildInputs = [ gtk3 ];

  gappsWrapperArgs = [
    "--prefix" "PATH" ":" "${stdenv.lib.makeBinPath [ xdotool which ]}"
  ];

  meta = with stdenv.lib; {
    description = "Lightweight GTK Clipboard Manager";
    inherit (src.meta) homepage;
    license     = licenses.gpl3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ kamilchm ];
  };
}
