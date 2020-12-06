{ stdenv, fetchFromGitHub, xorg, pkg-config
, cmake, libevdev
, gtkSupport ? true, gtk3, pcre, glib, wrapGAppsHook
, fltkSupport ? true, fltk
, qtSupport ? true, qt5
}:

stdenv.mkDerivation rec {
  pname = "xautoclick";
  version = "0.34";

  src = fetchFromGitHub {
    owner = "qarkai";
    repo = "xautoclick";
    rev = "v${version}";
    sha256 = "GN3zI5LQnVmRC0KWffzUTHKrxcqnstiL55hopwTTwpE=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libevdev xorg.libXtst ]
    ++ stdenv.lib.optionals gtkSupport [ gtk3 pcre glib wrapGAppsHook ]
    ++ stdenv.lib.optionals fltkSupport [ fltk ]
    ++ stdenv.lib.optionals qtSupport [ qt5.qtbase qt5.wrapQtAppsHook ];

  meta = with stdenv.lib; {
    description = "Autoclicker application, which enables you to automatically click the left mousebutton";
    homepage = "https://github.com/qarkai/xautoclick";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
