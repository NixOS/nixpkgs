{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  systemd,
  alsa-lib,
  dbus,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "q6voiced";
  version = "0.3.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitLab {
    domain = "gitlab.postmarketos.org";
    owner = "postmarketOS";
    repo = "q6voiced";
    tag = finalAttrs.version;
    hash = "sha256-VvhDaejcvCERU8oDgsjl3IuV5a8RjkA+pH8PJRHJWJs=";
  };

  mesonFlags = [
    # point to /etc/q6voiced/q6voiced.conf at runtime
    "--datadir=/etc"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    systemd
    dbus
    alsa-lib
  ];

  meta = {
    description = "Userspace daemon for the QDSP6 voice call audio driver";
    homepage = "https://gitlab.postmarketos.org/postmarketOS/q6voiced";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "q6voiced";
    platforms = lib.platforms.linux;
  };
})
