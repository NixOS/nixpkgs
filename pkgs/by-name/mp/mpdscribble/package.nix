{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  boost,
  curl,
  libgcrypt,
  libmpdclient,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mpdscribble";
  version = "0.25";

  src = fetchurl {
    url = "https://www.musicpd.org/download/mpdscribble/${finalAttrs.version}/mpdscribble-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-IPidlFv1F8TWi/d6d6NZ/bE4QqsSlejSHtp5vitbNc4=";
  };

  mesonFlags = [
    (lib.mesonOption "systemd_user_unit_dir" "etc/systemd/user")
    (lib.mesonOption "systemd_system_unit_dir" "etc/systemd/system")
  ];

  postPatch = ''
    sed '1i#include <ctime>' -i src/Log.cxx # gcc12
  '';

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];
  buildInputs = [
    libmpdclient
    curl
    boost
    libgcrypt
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux systemd;

  meta = {
    description = "MPD client which submits info about tracks being played to a scrobbler";
    homepage = "https://www.musicpd.org/clients/mpdscribble/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.sohalt ];
    platforms = lib.platforms.unix;
    mainProgram = "mpdscribble";
  };
})
