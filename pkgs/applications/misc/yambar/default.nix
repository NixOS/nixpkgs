{ stdenv
, lib
, fetchFromGitea
, pkg-config
, meson
, ninja
, scdoc
, alsa-lib
, fcft
, json_c
, libmpdclient
, libyaml
, pixman
, tllist
, udev
, wayland
, wayland-scanner
, wayland-protocols
, waylandSupport ? false
# Xorg backend
, libxcb
, xcbutil
, xcbutilcursor
, xcbutilerrors
, xcbutilwm
}:

let
  # Courtesy of sternenseemann and FRidh, commit c9a7fdfcfb420be8e0179214d0d91a34f5974c54
  mesonFeatureFlag = opt: b: "-D${opt}=${if b then "enabled" else "disabled"}";
in

stdenv.mkDerivation rec {
  pname = "yambar";
  version = "1.7.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "yambar";
    rev = version;
    sha256 = "sha256-NzJrlPOkzstMbw37yBTah/uFYezlPB/1hrxCiXduSmc=";
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
    wayland
    wayland-protocols
  ] ++ lib.optionals (!waylandSupport) [
    xcbutil
    xcbutilcursor
    xcbutilerrors
    xcbutilwm
  ];

  mesonBuildType = "release";

  mesonFlags = [
    (mesonFeatureFlag "backend-x11" (!waylandSupport))
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
