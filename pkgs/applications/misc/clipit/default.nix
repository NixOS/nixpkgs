{ fetchFromGitHub, lib, stdenv
, autoreconfHook, intltool, pkg-config
, gtk3, libayatana-appindicator, xdotool, which, wrapGAppsHook3 }:

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

  nativeBuildInputs = [ pkg-config wrapGAppsHook3 autoreconfHook intltool ];
  configureFlags = [ "--with-gtk3" "--enable-appindicator=yes" ];
  buildInputs = [ gtk3 libayatana-appindicator ];

  gappsWrapperArgs = [
    "--prefix" "PATH" ":" "${lib.makeBinPath [ xdotool which ]}"
  ];

  meta = with lib; {
    description = "Lightweight GTK Clipboard Manager";
    inherit (src.meta) homepage;
    license = licenses.gpl3Plus;
    platforms   = platforms.linux;
    mainProgram = "clipit";
    maintainers = with maintainers; [ kamilchm ];
  };
}
