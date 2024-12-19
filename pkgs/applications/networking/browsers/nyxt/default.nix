{
  stdenv,
  lib,
  testers,
  wrapGAppsHook3,
  fetchzip,
  sbcl,
  pkg-config,
  libfixposix,
  gobject-introspection,
  gsettings-desktop-schemas,
  glib-networking,
  notify-osd,
  gtk3,
  glib,
  gdk-pixbuf,
  cairo,
  pango,
  webkitgtk_4_0,
  openssl,
  gstreamer,
  gst-libav,
  gst-plugins-base,
  gst-plugins-good,
  gst-plugins-bad,
  gst-plugins-ugly,
  xdg-utils,
  xclip,
  wl-clipboard,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nyxt";
  version = "3.12.0";

  src = fetchzip {
    url = "https://github.com/atlas-engineer/nyxt/releases/download/${finalAttrs.version}/nyxt-${finalAttrs.version}-source-with-submodules.tar.xz";
    hash = "sha256-T5p3OaWp28rny81ggdE9iXffmuh6wt6XSuteTOT8FLI=";
    stripRoot = false;
  };

  nativeBuildInputs = [ wrapGAppsHook3 ];

  buildInputs = [
    sbcl
    # for groveller
    pkg-config
    libfixposix
    # for gappsWrapper
    gobject-introspection
    gsettings-desktop-schemas
    glib-networking
    notify-osd
    gtk3
    gstreamer
    gst-libav
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ];

  # for cffi
  LD_LIBRARY_PATH = lib.makeLibraryPath [
    glib
    gobject-introspection
    gdk-pixbuf
    cairo
    pango
    gtk3
    webkitgtk_4_0
    openssl
    libfixposix
  ];

  postConfigure = ''
    export CL_SOURCE_REGISTRY="$(pwd)/_build//"
    export ASDF_OUTPUT_TRANSLATIONS="$(pwd):$(pwd)"
    export PREFIX="$out"
    export NYXT_VERSION="$version"
  '';

  # don't refresh from git
  makeFlags = [
    "all"
    "NYXT_SUBMODULES=false"
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "$LD_LIBRARY_PATH")
    gappsWrapperArgs+=(--prefix PATH : "${
      lib.makeBinPath [
        xdg-utils
        xclip
        wl-clipboard
      ]
    }")
  '';

  # prevent corrupting core in exe
  dontStrip = true;

  passthru = {
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Infinitely extensible web-browser (with Lisp development files using WebKitGTK platform port)";
    mainProgram = "nyxt";
    homepage = "https://nyxt.atlas.engineer";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      lewo
      dariof4
    ];
    platforms = platforms.all;
  };
})
