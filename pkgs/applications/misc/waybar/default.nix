{ stdenv, fetchFromGitHub, meson, pkgconfig, ninja, wrapGAppsHook
, wayland, wlroots, gtkmm3, libinput, libsigcxx, jsoncpp, fmt, scdoc, spdlog, gtk-layer-shell
, howard-hinnant-date, cmake
, traySupport  ? true,  libdbusmenu-gtk3
, pulseSupport ? false, libpulseaudio
, nlSupport    ? true,  libnl
, udevSupport  ? true,  udev
, swaySupport  ? true,  sway
, mpdSupport   ? true,  mpd_clientlib
}:
  stdenv.mkDerivation rec {
    pname = "waybar";
    version = "0.9.1";

    src = fetchFromGitHub {
      owner = "Alexays";
      repo = "Waybar";
      rev = version;
      sha256 = "0drlv8im5phz39jxp3gxkc40b6f85bb3piff2v3hmnfzh7ib915s";
    };

    nativeBuildInputs = [
      meson ninja pkgconfig scdoc wrapGAppsHook cmake
    ];

    buildInputs = with stdenv.lib;
      [ wayland wlroots gtkmm3 libinput libsigcxx jsoncpp fmt spdlog gtk-layer-shell howard-hinnant-date ]
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
      "-Dsystemd=disabled"
    ];

    meta = with stdenv.lib; {
      description = "Highly customizable Wayland bar for Sway and Wlroots based compositors";
      license = licenses.mit;
      maintainers = with maintainers; [ FlorianFranzen minijackson synthetica ];
      platforms = platforms.unix;
      homepage = "https://github.com/alexays/waybar";
    };
  }
