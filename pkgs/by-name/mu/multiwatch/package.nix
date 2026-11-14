{
  lib,
  stdenv,
  fetchgit,
  meson,
  ninja,
  pkg-config,
  glib,
  libev,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "multiwatch";
  version = "1.0.1";

  src = fetchgit {
    url = "https://git.lighttpd.net/lighttpd/multiwatch.git";
    tag = "multiwatch-${finalAttrs.version}";
    hash = "sha256-v5M/qjvmFzLvOn5hntTBRV/16W8CCFHnZ/Q401Xb83g=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    glib
    libev
  ];

  strictDeps = true;

  __structuredAttrs = true;

  meta = {
    description = "Forks and watches multiple instances of a program in the same context";
    longDescription = ''
      Multiwatch forks multiple instance of one application and keeps them running.
      It is made to be used with spawn-fcgi, so all forks share the same fastcgi
      socket (no web server restart needed if you increase/decrease the number of
      forks), and it is easier than setting up multiple daemontool supervised
      instances.
    '';
    homepage = "https://redmine.lighttpd.net/projects/multiwatch";
    license = lib.licenses.mit;
    mainProgram = "multiwatch";
    maintainers = with lib.maintainers; [ definfo ];
    platforms = lib.platforms.unix;
  };
})
