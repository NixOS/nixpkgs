{ lib, stdenv, fetchFromGitHub, xorg, pkg-config
, cmake, libevdev
, withGtk3 ? true, gtk3, pcre, glib, wrapGAppsHook
, withFltk ? true, fltk
, withQt5 ? true, qt5
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
    ++ lib.optionals withGtk3 [ gtk3 pcre glib wrapGAppsHook ]
    ++ lib.optionals withFltk [ fltk ]
    ++ lib.optionals withQt5 [ qt5.qtbase qt5.wrapQtAppsHook ];

  meta = with lib; {
    description = "Autoclicker application, which enables you to automatically click the left mousebutton";
    homepage = "https://github.com/qarkai/xautoclick";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
