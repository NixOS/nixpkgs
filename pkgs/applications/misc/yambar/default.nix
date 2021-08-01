{ stdenv
, lib
, fetchgit
, pkg-config
, meson
, ninja
, scdoc
, alsa-lib
, fcft
, json_c
, libmpdclient
, libxcb
, libyaml
, pixman
, tllist
, udev
, wayland
, wayland-protocols
, xcbutil
, xcbutilcursor
, xcbutilerrors
, xcbutilwm
}:

stdenv.mkDerivation rec {
  pname = "yambar";
  version = "1.6.2";

  src = fetchgit {
    url = "https://codeberg.org/dnkl/yambar.git";
    rev = version;
    sha256 = "sha256-oUNkaWrYIcsK2u+aeRg6DHmH4M1VZ0leNSM0lV9Yy1Y=";
  };

  nativeBuildInputs = [ pkg-config meson ninja scdoc ];
  buildInputs = [
    alsa-lib
    fcft
    json_c
    libmpdclient
    libxcb
    libyaml
    pixman
    tllist
    udev
    wayland
    wayland-protocols
    xcbutil
    xcbutilcursor
    xcbutilerrors
    xcbutilwm
  ];

  meta = with lib; {
    homepage = "https://codeberg.org/dnkl/yambar";
    description = "Modular status panel for X11 and Wayland";
    longDescription = ''
      yambar is a lightweight and configurable status panel (bar, for short) for
      X11 and Wayland, that goes to great lengths to be both CPU and battery
      efficient - polling is only done when absolutely necessary.

      It has a number of modules that provide information in the form of
      tags. For example, the clock module has a date tag that contains the
      current date.

      The modules do not know how to present the information though. This is
      instead done by particles. And the user, you, decides which particles (and
      thus how to present the data) to use.

      Furthermore, each particle can have a decoration - a background color or a
      graphical underline, for example.

      There is no support for images or icons. use an icon font (e.g. Font
      Awesome, or Material Icons) if you want a graphical representation.

      There are a number of modules and particles builtin. More can be added as
      plugins. You can even write your own!

      To summarize: a bar displays information provided by modules, using
      particles and decorations. How is configured by you.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };
}
