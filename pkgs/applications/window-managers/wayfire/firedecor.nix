{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  boost,
  glib,
  libGL,
  libinput,
  librsvg,
  libxkbcommon,
  udev,
  wayfire,
  xcbutilwm,
  mate,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "firedecor";
  version = "2023-10-23";

  src = fetchFromGitHub {
    owner = "mntmn";
    repo = "Firedecor";
    rev = finalAttrs.version;
    hash = "sha256-7or8HkmIZnLpXEZzUhJ3u8SIPfIQFgn32Ju/5OzK06Y=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    boost
    glib
    libGL
    libinput
    librsvg
    libxkbcommon
    udev
    wayfire
    xcbutilwm
  ];

  postPatch = ''
    substituteInPlace src/firedecor-theme.cpp \
      --replace-fail "/usr/share" "/run/current-system/sw/share"
  '';

  env = {
    PKG_CONFIG_WAYFIRE_PLUGINDIR = "${placeholder "out"}/lib/wayfire";
    PKG_CONFIG_WAYFIRE_METADATADIR = "${placeholder "out"}/share/wayfire/metadata";
  };

  meta = with lib; {
    homepage = "https://github.com/mntmn/Firedecor";
    description = "Advanced window decoration plugin for the Wayfire window manager";
    license = licenses.mit;
    inherit (mate.mate-wayland-session.meta) maintainers;
    inherit (wayfire.meta) platforms;
  };
})
