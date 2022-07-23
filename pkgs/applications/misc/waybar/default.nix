{ lib
, stdenv
, fetchFromGitHub
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
, libxkbcommon
, runTests        ? true,  catch2
, traySupport     ? true,  libdbusmenu-gtk3
, pulseSupport    ? true,  libpulseaudio
, sndioSupport    ? true,  sndio
, nlSupport       ? true,  libnl
, udevSupport     ? true,  udev
, evdevSupport    ? true,  libevdev
, swaySupport     ? true,  sway
, mpdSupport      ? true,  libmpdclient
, rfkillSupport   ? true
, upowerSupport   ? true, upower
, withMediaPlayer ? false, glib, gobject-introspection, python3, python38Packages, playerctl
}:

stdenv.mkDerivation rec {
  pname = "waybar";
  version = "0.9.13";

  src = fetchFromGitHub {
    owner = "Alexays";
    repo = "Waybar";
    rev = version;
    sha256 = "sha256-Uzg2IrCDD8uUdGAveA8IjvonJnnnobOrAgjGG1kQ3pU=";
  };

  nativeBuildInputs = [
    meson ninja pkg-config scdoc wrapGAppsHook
  ] ++ lib.optional withMediaPlayer gobject-introspection;

  propagatedBuildInputs = lib.optionals withMediaPlayer [
    glib
    playerctl
    python38Packages.pygobject3
  ];
  strictDeps = false;

  buildInputs = with lib;
    [ wayland wlroots gtkmm3 libsigcxx jsoncpp spdlog gtk-layer-shell howard-hinnant-date libxkbcommon ]
    ++ optional  traySupport   libdbusmenu-gtk3
    ++ optional  pulseSupport  libpulseaudio
    ++ optional  sndioSupport  sndio
    ++ optional  nlSupport     libnl
    ++ optional  udevSupport   udev
    ++ optional  evdevSupport  libevdev
    ++ optional  swaySupport   sway
    ++ optional  mpdSupport    libmpdclient
    ++ optional  upowerSupport upower;

  checkInputs = [ catch2 ];
  doCheck = runTests;

  mesonFlags = (lib.mapAttrsToList
    (option: enable: "-D${option}=${if enable then "enabled" else "disabled"}")
    {
      dbusmenu-gtk = traySupport;
      pulseaudio = pulseSupport;
      sndio = sndioSupport;
      libnl = nlSupport;
      libudev = udevSupport;
      mpd = mpdSupport;
      rfkill = rfkillSupport;
      upower_glib = upowerSupport;
      tests = runTests;
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
    description = "Highly customizable Wayland bar for Sway and Wlroots based compositors";
    license = licenses.mit;
    maintainers = with maintainers; [ FlorianFranzen minijackson synthetica lovesegfault ];
    platforms = platforms.unix;
    homepage = "https://github.com/alexays/waybar";
  };
}
