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
, libinotify-kqueue
, libxkbcommon
, cavaSupport     ? true,  alsa-lib, fftw, iniparser, ncurses, pipewire, portaudio, SDL2
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
let
  # Derived from subprojects/cava.wrap
  libcava = rec {
    version = "0.8.4";
    src = fetchFromGitHub {
      owner = "LukashonakV";
      repo = "cava";
      rev = version;
      hash = "sha256-66uc0CEriV9XOjSjFTt+bxghEXY1OGrpjd+7d6piJUI=";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "waybar";
  version = "0.9.20";

  src = fetchFromGitHub {
    owner = "Alexays";
    repo = "Waybar";
    rev = version;
    hash = "sha256-xLcoysnCPB9+jI5cZokWWIvXM5wo3eXOe/hXfuChBR4=";
  };

  postUnpack = lib.optional cavaSupport ''
    (
      cd "$sourceRoot"
      cp -R --no-preserve=mode,ownership ${libcava.src} subprojects/cava-0.8.4
      patchShebangs .
    )
  '';

  nativeBuildInputs = [
    meson ninja pkg-config scdoc wrapGAppsHook
  ] ++ lib.optional withMediaPlayer gobject-introspection;

  propagatedBuildInputs = lib.optionals withMediaPlayer [
    glib
    playerctl
    python3.pkgs.pygobject3
  ];

  strictDeps = false;

  buildInputs = with lib;
    [ wayland wlroots gtkmm3 libsigcxx jsoncpp spdlog gtk-layer-shell howard-hinnant-date libxkbcommon ]
    ++ optional  (!stdenv.isLinux) libinotify-kqueue
    ++ optional  cavaSupport   alsa-lib
    ++ optional  cavaSupport   iniparser
    ++ optional  cavaSupport   fftw
    ++ optional  cavaSupport   ncurses
    ++ optional  cavaSupport   pipewire
    ++ optional  cavaSupport   portaudio
    ++ optional  cavaSupport   SDL2
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

  nativeCheckInputs = [ catch2_3 ];
  doCheck = runTests;

  mesonFlags = (lib.mapAttrsToList
    (option: enable: "-D${option}=${if enable then "enabled" else "disabled"}")
    {
      cava = cavaSupport;
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
