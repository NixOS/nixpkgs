{ lib
, stdenv
, fetchFromGitHub
<<<<<<< HEAD
, SDL2
, alsa-lib
, catch2_3
, fftw
, glib
, gobject-introspection
, gtk-layer-shell
, gtkmm3
, howard-hinnant-date
, hyprland
, iniparser
, jsoncpp
, libdbusmenu-gtk3
, libevdev
, libinotify-kqueue
, libinput
, libjack2
, libmpdclient
, libnl
, libpulseaudio
, libsigcxx
, libxkbcommon
, meson
, ncurses
, ninja
, pipewire
, pkg-config
, playerctl
, portaudio
, python3
, scdoc
, sndio
, spdlog
, sway
, udev
, upower
, wayland
, wireplumber
, wlroots
, wrapGAppsHook

, cavaSupport ? true
, evdevSupport ? true
, experimentalPatches ? true
, hyprlandSupport ? true
, inputSupport ? true
, jackSupport ? true
, mpdSupport ? true
, mprisSupport ? stdenv.isLinux
, nlSupport ? true
, pulseSupport ? true
, rfkillSupport ? true
, runTests ? true
, sndioSupport ? true
, swaySupport ? true
, traySupport ? true
, udevSupport ? true
, upowerSupport ? true
, wireplumberSupport ? true
, withMediaPlayer ? mprisSupport && false
}:

let
  # Derived from subprojects/cava.wrap
  libcava.src = fetchFromGitHub {
    owner = "LukashonakV";
    repo = "cava";
    rev = "0.8.5";
    hash = "sha256-b/XfqLh8PnW018sGVKRRlFvBpo2Ru1R2lUeTR7pugBo=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "waybar";
  version = "0.9.22";
=======
, meson
, pkg-config
, ninja
, wrapGAppsHook
, wayland
, wlroots
, gtkmm3
, libsigcxx
, jsoncpp
, scdoc
, spdlog
, gtk-layer-shell
, howard-hinnant-date
, libinotify-kqueue
, libxkbcommon
, evdevSupport    ? true,  libevdev
, inputSupport    ? true,  libinput
, jackSupport     ? true,  libjack2
, mpdSupport      ? true,  libmpdclient
, mprisSupport    ? stdenv.isLinux, playerctl ? false
, nlSupport       ? true,  libnl
, pulseSupport    ? true,  libpulseaudio
, rfkillSupport   ? true
, runTests        ? true,  catch2_3
, sndioSupport    ? true,  sndio
, swaySupport     ? true,  sway
, traySupport     ? true,  libdbusmenu-gtk3
, udevSupport     ? true,  udev
, upowerSupport   ? true,  upower
, wireplumberSupport ? true, wireplumber
, withMediaPlayer ? mprisSupport && false, glib, gobject-introspection, python3
}:

stdenv.mkDerivation rec {
  pname = "waybar";
  version = "0.9.17";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Alexays";
    repo = "Waybar";
<<<<<<< HEAD
    rev = finalAttrs.version;
    hash = "sha256-9LJDA+zrHF9Mn8+W9iUw50LvO+xdT7/l80KdltPrnDo=";
  };

  postUnpack = lib.optional cavaSupport ''
    pushd "$sourceRoot"
    cp -R --no-preserve=mode,ownership ${libcava.src} subprojects/cava-0.8.5
    patchShebangs .
    popd
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wrapGAppsHook
=======
    rev = version;
    hash = "sha256-sdNenmzI/yvN9w4Z83ojDJi+2QBx2hxhJQCFkc5kCZw=";
  };

  nativeBuildInputs = [
    meson ninja pkg-config scdoc wrapGAppsHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ lib.optional withMediaPlayer gobject-introspection;

  propagatedBuildInputs = lib.optionals withMediaPlayer [
    glib
    playerctl
    python3.pkgs.pygobject3
  ];

  strictDeps = false;

<<<<<<< HEAD
  buildInputs = [
    gtk-layer-shell
    gtkmm3
    howard-hinnant-date
    jsoncpp
    libsigcxx
    libxkbcommon
    spdlog
    wayland
    wlroots
  ]
  ++ lib.optionals cavaSupport [
    SDL2
    alsa-lib
    fftw
    iniparser
    ncurses
    pipewire
    portaudio
  ]
  ++ lib.optional evdevSupport libevdev
  ++ lib.optional hyprlandSupport hyprland
  ++ lib.optional inputSupport libinput
  ++ lib.optional jackSupport libjack2
  ++ lib.optional mpdSupport libmpdclient
  ++ lib.optional mprisSupport playerctl
  ++ lib.optional nlSupport libnl
  ++ lib.optional pulseSupport libpulseaudio
  ++ lib.optional sndioSupport sndio
  ++ lib.optional swaySupport sway
  ++ lib.optional traySupport libdbusmenu-gtk3
  ++ lib.optional udevSupport udev
  ++ lib.optional upowerSupport upower
  ++ lib.optional wireplumberSupport wireplumber
  ++ lib.optional (!stdenv.isLinux) libinotify-kqueue;
=======
  buildInputs = with lib;
    [ wayland wlroots gtkmm3 libsigcxx jsoncpp spdlog gtk-layer-shell howard-hinnant-date libxkbcommon ]
    ++ optional  (!stdenv.isLinux) libinotify-kqueue
    ++ optional  evdevSupport  libevdev
    ++ optional  inputSupport  libinput
    ++ optional  jackSupport   libjack2
    ++ optional  mpdSupport    libmpdclient
    ++ optional  mprisSupport  playerctl
    ++ optional  nlSupport     libnl
    ++ optional  pulseSupport  libpulseaudio
    ++ optional  sndioSupport  sndio
    ++ optional  swaySupport   sway
    ++ optional  traySupport   libdbusmenu-gtk3
    ++ optional  udevSupport   udev
    ++ optional  upowerSupport upower
    ++ optional  wireplumberSupport wireplumber;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeCheckInputs = [ catch2_3 ];
  doCheck = runTests;

<<<<<<< HEAD
  mesonFlags = (lib.mapAttrsToList lib.mesonEnable {
    "cava" = cavaSupport;
    "dbusmenu-gtk" = traySupport;
    "gtk-layer-shell" = true;
    "jack" = jackSupport;
    "libinput" = inputSupport;
    "libnl" = nlSupport;
    "libudev" = udevSupport;
    "man-pages" = true;
    "mpd" = mpdSupport;
    "mpris" = mprisSupport;
    "pulseaudio" = pulseSupport;
    "rfkill" = rfkillSupport;
    "sndio" = sndioSupport;
    "systemd" = false;
    "tests" = runTests;
    "upower_glib" = upowerSupport;
    "wireplumber" = wireplumberSupport;
  }) ++ lib.optional experimentalPatches (lib.mesonBool "experimental" true);

  preFixup = lib.optionalString withMediaPlayer ''
    cp $src/resources/custom_modules/mediaplayer.py $out/bin/waybar-mediaplayer.py

    wrapProgram $out/bin/waybar-mediaplayer.py \
      --prefix PYTHONPATH : "$PYTHONPATH:$out/${python3.sitePackages}"
  '';

  meta = {
    homepage = "https://github.com/alexays/waybar";
    description = "Highly customizable Wayland bar for Sway and Wlroots based compositors";
    changelog = "https://github.com/alexays/waybar/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "waybar";
    maintainers = with lib.maintainers; [
      FlorianFranzen
      jtbx
      lovesegfault
      minijackson
      rodrgz
      synthetica
      khaneliman
    ];
    inherit (wlroots.meta) platforms;
  };
})
=======
  mesonFlags = (lib.mapAttrsToList
    (option: enable: "-D${option}=${if enable then "enabled" else "disabled"}")
    {
      dbusmenu-gtk = traySupport;
      jack = jackSupport;
      libinput = inputSupport;
      libnl = nlSupport;
      libudev = udevSupport;
      mpd = mpdSupport;
      mpris = mprisSupport;
      pulseaudio = pulseSupport;
      rfkill = rfkillSupport;
      sndio = sndioSupport;
      tests = runTests;
      upower_glib = upowerSupport;
      wireplumber = wireplumberSupport;
    }
  ) ++ [
    "-Dsystemd=disabled"
    "-Dgtk-layer-shell=enabled"
    "-Dman-pages=enabled"
  ];

  preFixup = lib.optionalString withMediaPlayer ''
      cp $src/resources/custom_modules/mediaplayer.py $out/bin/waybar-mediaplayer.py

      wrapProgram $out/bin/waybar-mediaplayer.py \
        --prefix PYTHONPATH : "$PYTHONPATH:$out/${python3.sitePackages}"
    '';

  meta = with lib; {
    changelog = "https://github.com/alexays/waybar/releases/tag/${version}";
    description = "Highly customizable Wayland bar for Sway and Wlroots based compositors";
    license = licenses.mit;
    maintainers = with maintainers; [ FlorianFranzen minijackson synthetica lovesegfault rodrgz ];
    platforms = platforms.unix;
    homepage = "https://github.com/alexays/waybar";
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
