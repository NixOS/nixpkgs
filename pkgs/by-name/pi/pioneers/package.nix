{
  lib,
  stdenv,
  fetchsvn,
  autoreconfHook,
  desktopToDarwinBundle,
  gob2,
  intltool,
  itstool,
  libcanberra,
  avahi,
  gtk3,
  libnotify,
  librsvg,
  libxml2,
  pkg-config,
  gnome,
  wrapGAppsHook3,
  yelp-tools,
}:

stdenv.mkDerivation {
  pname = "pioneers";
  # No releases since 2021-07-07; track trunk HEAD at r2340 (latest) – SVN has no tags.
  version = "15.7-unstable-2021-07-07";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/pio/code/trunk/pioneers";
    rev = "2340";
    hash = "sha256-cggyPPza4QVbe9p68LdYHslTi3y9BMq6vDdsOW/u+X4=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  # Use merged gdk-pixbuf cache that includes librsvg's SVG loader (.dylib on darwin).
  # findGdkPixbufLoaders would otherwise pick the longest existing cache (librsvg's
  # alone or gdk-pixbuf's alone), missing the other set.
  GDK_PIXBUF_MODULE_FILE = lib.optionalString stdenv.hostPlatform.isDarwin "${
    gnome._gdkPixbufCacheBuilder_DO_NOT_USE
    { extraLoaders = [ librsvg ]; }
  }";

  nativeBuildInputs = [
    autoreconfHook
    gob2
    intltool
    itstool
    libxml2.bin
    # configure probes rsvg-convert with AC_PATH_PROG;
    librsvg
    pkg-config
    wrapGAppsHook3
    yelp-tools
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;

  buildInputs = [
    avahi
    gtk3
    libcanberra
    libnotify
    librsvg
  ];

  configureFlags = [
    "--enable-help"
    "--with-avahi"
    "--with-gtk"
    "--with-notify"
    "--with-sound"
  ];

  enableParallelBuilding = true;

  # Upstream puts a GNU ld option in AM_CFLAGS. Nix already performs the
  # equivalent dead-library elimination and Darwin's linker rejects it.
  makeFlags = [ "GOB2=${lib.getExe gob2}" ] ++ lib.optional stdenv.hostPlatform.isDarwin "AM_CFLAGS=";

  # librsvg's gdk-pixbuf loader is a .dylib with @rpath/librsvg-2.2.dylib; on darwin
  # the loader's rpath is empty, so DYLD must be set for dlopen to find it.
  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    for prog in $out/bin/*; do
      wrapProgram "$prog" \
        --prefix DYLD_LIBRARY_PATH : ${lib.getLib librsvg}/lib \
        --prefix DYLD_FALLBACK_LIBRARY_PATH : ${lib.getLib librsvg}/lib
    done
  '';

  meta = {
    description = "Multiplayer strategy game inspired by The Settlers of Catan";
    longDescription = ''
      Pioneers is a faithful implementation of The Settlers of Catan board
      game, supporting local and network multiplayer with GTK and Avahi
      discovery.
    '';
    homepage = "https://pio.sourceforge.net/";
    changelog = "https://sourceforge.net/p/pio/code/commit_browser";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.unix;
    mainProgram = "pioneers";
  };
}
