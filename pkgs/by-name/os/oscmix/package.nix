{
  lib,
  stdenv,

  fetchFromGitHub,

  pkgsCross,
  pkg-config,
  glib,
  wrapGAppsHook3,

  alsa-lib,
  gtk3,
  librsvg,
  hicolor-icon-theme,

  oscmix,
  unstableGitUpdater,

  alsaSupport ? stdenv.hostPlatform.isLinux,
  gtkSupport ? false,
  enableWebui ? false,
}:

stdenv.mkDerivation {
  pname = "oscmix";
  version = "0-unstable-2025-03-25";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "michaelforney";
    repo = "oscmix";
    rev = "b7b1c783b4a70fc7f014e378e287f86cf97bb20d";
    hash = "sha256-PVJPFt4AUElCpTWxEvU0W+w0JaitWoG2dSl1BkuT3lw=";
  };

  nativeBuildInputs =
    lib.optionals (alsaSupport || gtkSupport) [ pkg-config ]
    ++ lib.optionals (gtkSupport) [
      glib
      wrapGAppsHook3
    ]
    ++ lib.optionals (enableWebui) [ pkgsCross.wasi32.stdenv.cc.bintools ];

  buildInputs =
    lib.optionals alsaSupport [ alsa-lib ]
    ++ lib.optionals gtkSupport [
      gtk3
      librsvg
      hicolor-icon-theme
    ];

  makeFlags =
    let
      option = bool: if bool then "y" else "n";
    in
    [
      "ALSA=${option alsaSupport}"
      "GTK=${option gtkSupport}"
      "WEB=${option enableWebui}"
    ]
    ++ lib.optionals (enableWebui) [
      "WASM_CC=${lib.getExe pkgsCross.wasi32.stdenv.cc}"
    ];

  installFlags = [
    "PREFIX=$(out)"
    "MANDIR=$(man)/share/man"
  ];

  postInstall = lib.optionalString gtkSupport ''
    pushd gtk

    schemadir="${glib.makeSchemaPath "$out" "$name"}"

    mkdir -p "$schemadir"
    cp gschemas.compiled "$schemadir"
    cp *.{ui,css,svg} "$schemadir"

    cp oscmix-gtk "$out/bin/"

    popd
  '';

  dontWrapGApps = true;

  fixupPhase = lib.optionalString gtkSupport ''
    runHook preFixup

    wrapGApp "$out/bin/oscmix-gtk"

    runHook postFixup
  '';

  passthru = {
    tests = {
      oscmix-gtk = oscmix.override { gtkSupport = true; };
      oscmix-web = oscmix.override { enableWebui = true; };
    };

    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "Open Sound Control API for RME Fireface UCX II";
    homepage = "https://github.com/michaelforney/oscmix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mvs ];
    platforms = if alsaSupport then lib.platforms.linux else lib.platforms.all;
  };
}
