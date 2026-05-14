{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  gi-docgen,
  meson,
  ninja,
  pkg-config,
  vala,
  gobject-introspection,
  gperf,
  glib,
  cairo,
  sqlite,
  libsoup_3,
  gtk4,
  libsysprof-capture,
  json-glib,
  protobufc,
  xvfb-run,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libshumate";
  version = "1.5.3";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];
  outputBin = "devdoc"; # demo app

  src = fetchurl {
    url = "mirror://gnome/sources/libshumate/${lib.versions.majorMinor finalAttrs.version}/libshumate-${finalAttrs.version}.tar.xz";
    hash = "sha256-NfATslORhW4bXD1ECaXEpkDGzLX1KW/5gux77Tn1bUw=";
  };

  patches = [
    (fetchpatch {
      # Required for cross-compiled libshumate to get $dev/share/vala/vapi/shumate-1.0.{deps,vapi}
      # https://gitlab.gnome.org/GNOME/libshumate/-/merge_requests/263
      url = "https://gitlab.gnome.org/GNOME/libshumate/-/commit/8a8a5013ed69f443b84500b4f745079025863a32.patch";
      name = "meson-use-find_program-instead-of-dependency-for-vapigen";
      hash = "sha256-nYLUMLcghnWU/hlCWOHMmFIUdDa7UkX4TP7C4ftZVJM=";
    })
  ];

  depsBuildBuild = [
    # required to find native gi-docgen when cross compiling
    pkg-config
  ];

  nativeBuildInputs = [
    gi-docgen
    meson
    ninja
    pkg-config
    vala
    gobject-introspection
    gperf
  ];

  buildInputs = [
    glib
    cairo
    sqlite
    libsoup_3
    gtk4
    libsysprof-capture
    json-glib
    protobufc
  ];

  nativeCheckInputs = [
    xvfb-run
  ];

  mesonFlags = [
    "-Ddemos=true"
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  checkPhase = ''
    runHook preCheck

    env \
      HOME="$TMPDIR" \
      GTK_A11Y=none \
      xvfb-run meson test --print-errorlogs

    runHook postCheck
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput share/doc/libshumate-1.0 "$devdoc"
  '';

  strictDeps = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "libshumate";
    };
  };

  meta = {
    description = "GTK toolkit providing widgets for embedded maps";
    mainProgram = "shumate-demo";
    homepage = "https://gitlab.gnome.org/GNOME/libshumate";
    license = lib.licenses.lgpl21Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.unix;
  };
})
