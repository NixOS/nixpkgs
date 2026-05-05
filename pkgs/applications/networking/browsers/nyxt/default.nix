{
  stdenv,
  lib,
  testers,
  wrapGAppsHook3,
  fetchFromGitHub,
  sbcl,
  sbclPackages,
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
  nixosTests,
  enchant_2,
  electronSupport ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nyxt";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "atlas-engineer";
    repo = "nyxt";
    tag = finalAttrs.version;
    hash = "sha256-4m8Obnv0hqNMZZ1luZzmlBRR1aZiRAr//bjQkFjI+CM=";
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
    gtk3
    gstreamer
    gst-libav
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly

    enchant_2
    sbclPackages.sqlite
    sbclPackages.enchant
  ]
  ++ (with sbclPackages; [
    alexandria
    bordeaux-threads
    calispel
    cl-base64
    cl-colors-ng
    cl-gopher
    cl-json
    cl-ppcre
    cl-ppcre-unicode
    cl-prevalence
    cl-qrencode
    cl-tld
    closer-mop
    clss
    dexador
    flexi-streams
    iolib
    lass
    local-time
    log4cl
    lparallel
    nclasses
    nfiles
    nhooks
    nkeymaps
    parenscript
    phos
    plump
    prompter
    py-configparser
    quri
    serapeum
    spinneret
    str
    trivia
    trivial-arguments
    trivial-clipboard
    trivial-package-local-nicknames
    trivial-types
    unix-opts
  ])
  ++ lib.optionals electronSupport [ sbclPackages.cl-electron ];

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
    export NYXT_VERSION="$version"
  '';

  # don't refresh from git
  makeFlags = [
    "all"
    "NYXT_SUBMODULES=true"
  ]
  ++ lib.optionals electronSupport [ "NYXT_RENDERER=electron" ];

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
