{
  lib,
  epoll-shim,
  fetchFromGitLab,
  glib,
  json-glib,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  stdenv,
  enableEpollShim ? lib.meta.availableOn stdenv.hostPlatform epoll-shim,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gmobile";
  version = "0.2.1";

  src = fetchFromGitLab {
    pname = "gmobile-source";
    inherit (finalAttrs) version;
    domain = "gitlab.gnome.org";
    owner = "World/Phosh";
    repo = "gmobile";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5OQ2JT7YeEYzKXafwgg0xJk2AvtFw2dtcH3mt+cm1bI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    json-glib
    glib
    gobject-introspection
  ] ++ lib.optionals enableEpollShim [ epoll-shim ];

  meta = {
    homepage = "https://world.pages.gitlab.gnome.org/Phosh/gmobile/";
    description = "Functions useful in mobile related, glib based projects";
    longDescription = ''
      gmobile carries some helpers for glib based environments on mobile
      devices. Some of those parts might move to glib or libgnome-desktop
      eventually. It can be used as a shared library or git submodule. There
      aren't any API stability guarantees at this point in time.
    '';
    license = with lib.licenses; [ gpl3Plus ];
    mainProgram = "gm-timeout";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
