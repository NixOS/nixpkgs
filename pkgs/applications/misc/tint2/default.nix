{ lib, stdenv
, fetchFromGitLab
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pkg-config
, cmake
, gettext
, cairo
, pango
, pcre
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
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "tint2";
<<<<<<< HEAD
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

=======
  version = "17.0.2";

  src = fetchFromGitLab {
    owner = "o9000";
    repo = "tint2";
    rev = version;
    sha256 = "sha256-SqpAjclwu3HN07LAZgvXGzjMK6G+nYLDdl90o1+9aog=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    pkg-config
    cmake
    gettext
    wrapGAppsHook
  ];

  buildInputs = [
    cairo
    pango
    pcre
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
<<<<<<< HEAD
    homepage = "https://gitlab.com/nick87720z/tint2";
=======
    homepage = "https://gitlab.com/o9000/tint2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Simple panel/taskbar unintrusive and light (memory, cpu, aestetic)";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
