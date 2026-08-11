{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
  pkg-config,
  autoreconfHook,
  wrapGAppsHook3,
  kdePackages,
  libgpg-error,
  libassuan,
  libsForQt5,
  qt6,
  ncurses,
  gtk2,
  gcr,
  withLibsecret ? true,
  libsecret,
}:

let
  buildFlavors = [
    "qt"
    "curses"
    "tty"
  ];

  flavorInfo = {
    tty = {
      flag = "tty";
    };
    curses = {
      flag = "curses";
      buildInputs = [ ncurses ];
    };
    gtk2 = {
      flag = "gtk2";
      buildInputs = [ gtk2 ];
    };
    gnome3 = {
      flag = "gnome3";
      buildInputs = [ gcr ];
      nativeBuildInputs = [ wrapGAppsHook3 ];
    };
    qt5 = {
      flag = "qt5";
      buildInputs = [
        libsForQt5.qtbase
        kdePackages.kwayland
        libsForQt5.qtx11extras
      ];
      nativeBuildInputs = [ libsForQt5.wrapQtAppsHook ];
    };
    qt = {
      flag = "qt";
      buildInputs = [
        qt6.qtbase
        qt6.qtwayland
        kdePackages.kguiaddons
      ];
      nativeBuildInputs = [ qt6.wrapQtAppsHook ];
    };
    emacs = {
      flag = "emacs";
    };
  };

  enableFeaturePinentry =
    f: lib.enableFeature (lib.elem f buildFlavors) ("pinentry-" + flavorInfo.${f}.flag);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pinentry-qt";
  version = "1.3.2";

  src = fetchurl {
    url = "mirror://gnupg/pinentry/pinentry-${finalAttrs.version}.tar.bz2";
    hash = "sha256-jphu2IVhtNpunv4MVPpMqJIwNcmSZN8LBGRJfF+5Tp4=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ]
  ++ lib.concatMap (f: flavorInfo.${f}.nativeBuildInputs or [ ]) buildFlavors;

  buildInputs = [
    libgpg-error
    libassuan
  ]
  ++ lib.optional withLibsecret libsecret
  ++ lib.concatMap (f: flavorInfo.${f}.buildInputs or [ ]) buildFlavors;

  dontWrapGApps = true;
  dontWrapQtApps = true;

  patches = [
    ./autoconf-ar.patch
    ./gettext-0.25.patch
  ]
  ++ lib.optionals (lib.elem "gtk2" buildFlavors) [
    (fetchpatch {
      url = "https://salsa.debian.org/debian/pinentry/raw/debian/1.1.0-1/debian/patches/0007-gtk2-When-X11-input-grabbing-fails-try-again-over-0..patch";
      hash = "sha256-zUHrYpy68Fo74arWSLwUHb+zYz39l8fT/7S54VdXIZc=";
    })
  ];

  configureFlags = [
    "--with-libgpg-error-prefix=${libgpg-error.dev}"
    "--with-libassuan-prefix=${libassuan.dev}"
    (lib.enableFeature withLibsecret "libsecret")
  ]
  ++ (map enableFeaturePinentry (lib.attrNames flavorInfo));

  postInstall =
    lib.optionalString (lib.elem "gnome3" buildFlavors) ''
      wrapGApp $out/bin/pinentry-gnome3
    ''
    + lib.optionalString (lib.elem "qt5" buildFlavors) ''
      wrapQtApp $out/bin/pinentry-qt5
      ln -sf $out/bin/pinentry-qt5 $out/bin/pinentry-qt
    ''
    + lib.optionalString (lib.elem "qt" buildFlavors) ''
      wrapQtApp $out/bin/pinentry-qt
    '';

  passthru = {
    flavors = buildFlavors;
  };

  meta = {
    homepage = "https://gnupg.org/software/pinentry/index.html";
    description = "GnuPG’s interface to passphrase input";
    license = lib.licenses.gpl2Plus;
    platforms =
      if lib.elem "gnome3" buildFlavors then
        lib.platforms.linux
      else if (lib.elem "qt5" buildFlavors || lib.elem "qt" buildFlavors) then
        (lib.remove "aarch64-darwin" lib.platforms.all)
      else
        lib.platforms.all;
    longDescription = ''
      Pinentry provides a console and (optional) GTK and Qt GUIs allowing users
      to enter a passphrase when `gpg` or `gpg2` is run and needs it.
    '';
    maintainers = with lib.maintainers; [ fpletz ];
    mainProgram = "pinentry";
  };
})
