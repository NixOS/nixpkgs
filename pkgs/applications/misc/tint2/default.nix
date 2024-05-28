{ lib, stdenv
, fetchFromGitLab
, fetchpatch
, pkg-config
, cmake
, gettext
, cairo
, pango
, glib
, imlib2
, gtk3
, libXinerama
, libXrender
, libXcomposite
, libXdamage
, libX11
, libXrandr
, librsvg
, libpthreadstubs
, libXdmcp
, libstartup_notification
, wrapGAppsHook3
}:

stdenv.mkDerivation rec {
  pname = "tint2";
  version = "17.1.3";

  src = fetchFromGitLab {
    owner = "nick87720z";
    repo = "tint2";
    rev = version;
    hash = "sha256-9sEe/Gnj+FWLPbWBtfL1YlNNC12j7/KjQ40xdkaFJVQ=";
  };

  patches = [
    # Fix crashes with glib >= 2.76
    # https://patchespromptly.com/glib2/
    # https://gitlab.com/nick87720z/tint2/-/issues/4
    (fetchpatch {
      url = "https://gitlab.com/nick87720z/tint2/uploads/7de4501a4fa4fffa5ba8bb0fa3d19f78/glib.patch";
      hash = "sha256-K547KYlRkVl1s2THi3ZCRuM447EFJwTqUEBjKQnV8Sc=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    gettext
    wrapGAppsHook3
  ];

  buildInputs = [
    cairo
    pango
    glib
    imlib2
    gtk3
    libXinerama
    libXrender
    libXcomposite
    libXdamage
    libX11
    libXrandr
    librsvg
    libpthreadstubs
    libXdmcp
    libstartup_notification
  ];

  cmakeFlags = [
    "-Ddocdir=share/doc/${pname}"
  ];

  postPatch = ''
    for f in ./src/launcher/apps-common.c \
             ./src/launcher/icon-theme-common.c
    do
      substituteInPlace $f --replace /usr/share/ /run/current-system/sw/share/
    done
  '';

  meta = with lib; {
    homepage = "https://gitlab.com/nick87720z/tint2";
    description = "Simple panel/taskbar unintrusive and light (memory, cpu, aestetic)";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
