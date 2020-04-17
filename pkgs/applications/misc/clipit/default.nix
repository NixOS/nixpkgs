{ fetchFromGitHub, fetchpatch, stdenv
, autoreconfHook, intltool, pkgconfig
, gtk3, xdotool, which, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "clipit";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "shantzu";
    repo = "ClipIt";
    rev = "v${version}";
    sha256 = "05xi29v2y0rvb33fmvrz7r9j4l858qj7ngwd7dp4pzpkkaybjln0";
  };

  patches = [
   # gtk3 support, can be removed in the next release
   (fetchpatch {
     url = "https://github.com/CristianHenzel/ClipIt/commit/22e012c7d406436e1785b6dd3c4c138b25f68431.patch";
     sha256 = "0la4gc324dzxpx6nk2lqg5fmjgjpm2pyvzwddmfz1il8hqvrqg3j";
   })
  ];

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
  };
}
