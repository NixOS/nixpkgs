{ stdenv, fetchFromGitHub, meson, pkgconfig, ninja
, wayland, wlroots, gtkmm3, libinput, libsigcxx, jsoncpp, fmt
, traySupport  ? true,  libdbusmenu-gtk3
, pulseSupport ? false, libpulseaudio
, nlSupport    ? true,  libnl
, swaySupport  ? true,  sway
}:
  stdenv.mkDerivation rec {
    name = "waybar-${version}";
    version = "0.4.0";

    src = fetchFromGitHub {
      owner = "Alexays";
      repo = "Waybar";
      rev = version;
      sha256 = "0vkx1b6bgr75wkx89ppxhg4103vl2g0sky22npmfkvbkpgh8dj38";
    };

    nativeBuildInputs = [
      meson ninja pkgconfig
    ];

    buildInputs = with stdenv.lib;
      [ wayland wlroots gtkmm3 libinput libsigcxx jsoncpp fmt ]
      ++ optional  traySupport  libdbusmenu-gtk3
      ++ optional  pulseSupport libpulseaudio
      ++ optional  nlSupport    libnl
      ++ optional  swaySupport  sway;

    mesonFlags = [
      "-Ddbusmenu-gtk=${ if traySupport then "enabled" else "disabled" }"
      "-Dpulseaudio=${ if pulseSupport then "enabled" else "disabled" }"
      "-Dlibnl=${ if nlSupport then "enabled" else "disabled" }"
      "-Dout=${placeholder "out"}"
    ];

    meta = with stdenv.lib; {
      description = "Highly customizable Wayland bar for Sway and Wlroots based compositors";
      license = licenses.mit;
      maintainers = [ maintainers.FlorianFranzen ];
      platforms = platforms.unix;
    };
  }
