{
  stdenv,
  lib,
  testers,
  wrapGAppsHook3,
  fetchzip,
  sbcl_2_4_6,
  pkg-config,
  libfixposix,
  gobject-introspection,
  gsettings-desktop-schemas,
  glib-networking,
  gtk3,
  glib,
  gdk-pixbuf,
  cairo,
  pango,
  webkitgtk_4_1,
  openssl,
  sqlite,
  gst_all_1,
  xdg-utils,
  xclip,
  wl-clipboard,
  nix-update-script,
  nixosTests,
  dejavu_fonts,
  makeFontsConf,
}:
let
  sbcl = sbcl_2_4_6;
  customFontsConf = makeFontsConf {
    fontDirectories = [
      dejavu_fonts
    ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nyxt";
  version = "3.12.0";

  src = fetchzip {
    url = "https://github.com/atlas-engineer/nyxt/releases/download/${finalAttrs.version}/nyxt-${finalAttrs.version}-source-with-submodules.tar.xz";
    hash = "sha256-T5p3OaWp28rny81ggdE9iXffmuh6wt6XSuteTOT8FLI=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
    pkg-config
  ];

  buildInputs = [
    sbcl
    libfixposix
    gsettings-desktop-schemas
    glib-networking
    gtk3
    webkitgtk_4_1
    gst_all_1.gstreamer
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    dejavu_fonts
  ];

  FONTCONFIG_FILE = customFontsConf;

  # for cffi
  env.LD_LIBRARY_PATH = lib.makeLibraryPath [
    glib
    gobject-introspection
    gdk-pixbuf
    cairo
    pango
    gtk3
    webkitgtk_4_1
    openssl
    sqlite
    libfixposix
  ];

  postConfigure = ''
    export CL_SOURCE_REGISTRY="$(pwd)/_build//"
    export ASDF_OUTPUT_TRANSLATIONS="$(pwd):$(pwd)"
    export PREFIX="$out"
    export NYXT_VERSION="${finalAttrs.version}"
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
    gappsWrapperArgs+=(--set FONTCONFIG_FILE "${customFontsConf}")
  '';

  # prevent corrupting core in exe
  dontStrip = true;

  passthru = {
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
    updateScript = nix-update-script { };
    tests = { inherit (nixosTests) nyxt; };
  };

  meta = {
    description = "Infinitely extensible web-browser (with Lisp development files using WebKitGTK platform port)";
    mainProgram = "nyxt";
    homepage = "https://nyxt.atlas.engineer";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      lewo
      dariof4
    ];
    platforms = lib.platforms.all;
  };
})
