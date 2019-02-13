{ stdenv, fetchFromGitHub, pkgconfig, libsoup, webkit, gtk3, glib-networking
, gsettings-desktop-schemas, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  name = "vimb-${version}";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "fanglingsu";
    repo = "vimb";
    rev = version;
    sha256 = "1qg18z2gnsli9qgrqfhqfrsi6g9mcgr90w8yab28nxrq4aha6brf";
  };

  nativeBuildInputs = [ wrapGAppsHook pkgconfig ];
  buildInputs = [ gtk3 libsoup webkit glib-networking gsettings-desktop-schemas ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "A Vim-like browser";
    longDescription = ''
      A fast and lightweight vim like web browser based on the webkit web
      browser engine and the GTK toolkit. Vimb is modal like the great vim
      editor and also easily configurable during runtime. Vimb is mostly
      keyboard driven and does not detract you from your daily work.
    '';
    homepage = https://fanglingsu.github.io/vimb/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.rickynils ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
