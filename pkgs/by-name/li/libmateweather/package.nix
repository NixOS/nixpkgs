{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf-archive,
  autoreconfHook,
  pkg-config,
  gettext,
  glib,
  glib-networking,
  libxml2,
  gtk3,
  gtk-doc,
  libsoup_3,
  tzdata,
  mate-common,
  gitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libmateweather";
  version = "1.28.2";

  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = "libmateweather";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D9A9zHd0stCV5Lynyb0N9LuenBk1eJa4ZdQcZQf6UpU=";
  };

  patches = [
    # https://github.com/mate-desktop/libmateweather/pull/133
    ./libsoup_3_support.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook # the libsoup patch changes the autoconf file
    pkg-config
    gettext
    glib # glib-compile-schemas
    gtk3 # gtk-update-icon-cache
    gtk-doc # required for autoconf
    libxml2 # xmllint
    mate-common # mate-compiler-flags.m4 macros
  ];

  buildInputs = [
    libxml2
    libsoup_3
    tzdata
  ];

  propagatedBuildInputs = [
    glib
    glib-networking # for obtaining IWIN forecast data
    gtk3
  ];

  configureFlags = [
    "--with-zoneinfo-dir=${tzdata}/share/zoneinfo"
  ];

  preFixup = "rm -f $out/share/icons/mate/icon-theme.cache";

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    url = "https://git.mate-desktop.org/libmateweather";
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "Library to access weather information from online services for MATE";
    homepage = "https://github.com/mate-desktop/libmateweather";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
