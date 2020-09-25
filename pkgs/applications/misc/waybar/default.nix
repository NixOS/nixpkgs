{ stdenv, fetchFromGitHub, meson, pkgconfig, ninja, wrapGAppsHook
, wayland, wlroots, gtkmm3, libsigcxx, jsoncpp, fmt, scdoc, spdlog, gtk-layer-shell
, howard-hinnant-date, cmake
, traySupport  ? true,  libdbusmenu-gtk3
, pulseSupport ? false, libpulseaudio
, nlSupport    ? true,  libnl
, udevSupport  ? true,  udev
, swaySupport  ? true,  sway
, mpdSupport   ? true,  mpd_clientlib
, withMediaPlayer ? false, glib, gobject-introspection, python3, python38Packages, playerctl
}:
  stdenv.mkDerivation rec {
    pname = "waybar";
    version = "0.9.3";

    src = fetchFromGitHub {
      owner = "Alexays";
      repo = "Waybar";
      rev = version;
      sha256 = "0ks719khhg2zwpyiwa2079i6962qcxpapm28hmr4ckpsp2n659ck";
    };

    nativeBuildInputs = [
      meson ninja pkgconfig scdoc wrapGAppsHook cmake
    ] ++ stdenv.lib.optional withMediaPlayer gobject-introspection;

    propagatedBuildInputs = stdenv.lib.optionals withMediaPlayer [
      glib
      playerctl
      python38Packages.pygobject3
    ];
    strictDeps = false;

    buildInputs = with stdenv.lib;
      [ wayland wlroots gtkmm3 libsigcxx jsoncpp fmt spdlog gtk-layer-shell howard-hinnant-date ]
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

    preFixup = stdenv.lib.optional withMediaPlayer ''
      cp $src/resources/custom_modules/mediaplayer.py $out/bin/waybar-mediaplayer.py

      wrapProgram $out/bin/waybar-mediaplayer.py \
        --prefix PYTHONPATH : "$PYTHONPATH:$out/${python3.sitePackages}"
    '';

    meta = with stdenv.lib; {
      description = "Highly customizable Wayland bar for Sway and Wlroots based compositors";
      license = licenses.mit;
      maintainers = with maintainers; [ FlorianFranzen minijackson synthetica ];
      platforms = platforms.unix;
      homepage = "https://github.com/alexays/waybar";
    };
  }
