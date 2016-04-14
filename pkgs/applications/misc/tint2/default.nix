{ stdenv, fetchFromGitLab, pkgconfig, cmake, gettext, pango, cairo, glib
, pcre , imlib2, libXinerama , libXrender, libXcomposite, libXdamage, libX11
, libXrandr, gtk, libpthreadstubs , libXdmcp, librsvg
, libstartup_notification, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  name = "tint2-${version}";
  version = "0.12.9";

  src = fetchFromGitLab {
    owner = "o9000";
    repo = "tint2";
    rev = version;
    sha256 = "17n3yssqiwxqrwsxypzw8skwzxm2540ikbyx7kfxv2gqlbjx5y6q";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig cmake gettext wrapGAppsHook ];

  buildInputs = [ pango cairo glib pcre imlib2 libXinerama libXrender
    libXcomposite libXdamage libX11 libXrandr gtk libpthreadstubs libXdmcp
    librsvg libstartup_notification ];

  preConfigure = ''
    substituteInPlace CMakeLists.txt --replace /etc $out/etc
  '';

  prePatch = ''
    for f in ./src/tint2conf/properties.c \
             ./src/launcher/apps-common.c \
             ./src/launcher/icon-theme-common.c \
             ./themes/*tint2rc
    do
      substituteInPlace $f --replace /usr/share/ /run/current-system/sw/share/
    done
  '';

  meta = {
    homepage = https://gitlab.com/o9000/tint2;
    license = stdenv.lib.licenses.gpl2;
    description = "A simple panel/taskbar unintrusive and light (memory / cpu / aestetic)";
    platforms = stdenv.lib.platforms.linux;
  };
}
