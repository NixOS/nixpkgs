{ stdenv, fetchFromGitHub, meson, pkgconfig, ninja
, wayland, wlroots, gtkmm3, libinput, libsigcxx, jsoncpp, fmt, scdoc, spdlog
, traySupport  ? true,  libdbusmenu-gtk3
, pulseSupport ? false, libpulseaudio
, nlSupport    ? true,  libnl
, udevSupport  ? true,  udev
, swaySupport  ? true,  sway
, mpdSupport   ? true,  mpd_clientlib
}:
  stdenv.mkDerivation rec {
    pname = "waybar";
    version = "0.8.0";

    src = fetchFromGitHub {
      owner = "Alexays";
      repo = "Waybar";
      rev = version;
      sha256 = "0s8ck7qxka0l91ayma6amp9sc8cidi43byqgzcavi3a6id983r1z";
    };

    nativeBuildInputs = [
      meson ninja pkgconfig scdoc
    ];

    buildInputs = with stdenv.lib;
      [ wayland wlroots gtkmm3 libinput libsigcxx jsoncpp fmt spdlog ]
      ++ optional  traySupport  libdbusmenu-gtk3
      ++ optional  pulseSupport libpulseaudio
      ++ optional  nlSupport    libnl
      ++ optional  udevSupport  udev
      ++ optional  swaySupport  sway
      ++ optional  mpdSupport   mpd_clientlib;

    mesonFlags = (stdenv.lib.mapAttrsToList
      (option: enable: "-D${option}=${if enable then "enabled" else "disabled"}")
      {
        dbusmenu-gtk = traySupport;
        pulseaudio = pulseSupport;
        libnl = nlSupport;
        libudev = udevSupport;
        mpd = mpdSupport;
      }
    ) ++ [
      "-Dout=${placeholder "out"}"
    ];

    meta = with stdenv.lib; {
      description = "Highly customizable Wayland bar for Sway and Wlroots based compositors";
      license = licenses.mit;
      maintainers = with maintainers; [ FlorianFranzen minijackson synthetica ];
      platforms = platforms.unix;
    };
  }
