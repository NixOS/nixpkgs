{ lib
, stdenv
, fetchFromGitea
, alsa-lib
, fcft
, json_c
, libmpdclient
, libxcb
, libyaml
, meson
, ninja
, pixman
, pkg-config
, scdoc
, tllist
, udev
, wayland
, wayland-protocols
, wayland-scanner
, xcbutil
, xcbutilcursor
, xcbutilerrors
, xcbutilwm
, waylandSupport ? true
, x11Support ? true
}:

let
  # Courtesy of sternenseemann and FRidh
  mesonFeatureFlag = feature: flag:
    "-D${feature}=${if flag then "enabled" else "disabled"}";
in
stdenv.mkDerivation rec {
  pname = "yambar";
  version = "1.8.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "yambar";
    rev = version;
    hash = "sha256-zXhIXT3JrVSllnYheDU2KK3NE2VYa+xuKufIXjdMFjU=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    scdoc
    wayland-scanner
  ];

  buildInputs = [
    alsa-lib
    fcft
    json_c
    libmpdclient
    libyaml
    pixman
    tllist
    udev
  ] ++ lib.optionals (waylandSupport) [
    wayland
    wayland-protocols
  ] ++ lib.optionals (x11Support) [
    xcbutil
    xcbutilcursor
    xcbutilerrors
    xcbutilwm
  ];

  mesonBuildType = "release";

  mesonFlags = [
    (mesonFeatureFlag "backend-x11" x11Support)
    (mesonFeatureFlag "backend-wayland" waylandSupport)
  ];

  meta = with lib; {
    homepage = "https://codeberg.org/dnkl/yambar";
    changelog = "https://codeberg.org/dnkl/yambar/releases/tag/${version}";
    description = "Modular status panel for X11 and Wayland";
    longDescription = ''
      yambar is a lightweight and configurable status panel (bar, for short) for
      X11 and Wayland, that goes to great lengths to be both CPU and battery
      efficient - polling is only done when absolutely necessary.

      It has a number of modules that provide information in the form of tags.
      For example, the clock module has a date tag that contains the current
      date.

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
