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
  systemdLibs,
  fmt,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mpdscribble";
  version = "0.26";

  __structuredAttrs = true;

  src = fetchurl {
    url = "https://www.musicpd.org/download/mpdscribble/${finalAttrs.version}/mpdscribble-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-udWCm4nEZXByVsFAAA4aBLHZ06/lDbRqhDz17lS/Ywk=";
  };

  mesonFlags = [
    (lib.mesonOption "systemd_user_unit_dir" "etc/systemd/user")
    (lib.mesonOption "systemd_system_unit_dir" "etc/systemd/system")
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    versionCheckHook
  ];

  buildInputs = [
    libmpdclient
    curl
    boost
    libgcrypt
    fmt
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux systemdLibs;

  doInstallCheck = true;

  meta = {
    description = "MPD client which submits info about tracks being played to a scrobbler";
    homepage = "https://www.musicpd.org/clients/mpdscribble/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      sohalt
      kybe236
    ];
    platforms = lib.platforms.unix;
    mainProgram = "mpdscribble";
  };
})
