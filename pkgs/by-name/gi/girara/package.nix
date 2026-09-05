{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  check,
  dbus,
  xvfb-run,
  glib,
  gtk3,
  gettext,
  libiconv,
  json-glib,
  libintl,
  zathura,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "girara";
  version = "2026.07.18";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "pwmt";
    repo = "girara";
    tag = finalAttrs.version;
    hash = "sha256-Q4IbB8Wecob9NH6UPqyIifyd3D+IpMCfe725U3htR+s=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    check
    dbus
    glib # for glib-compile-resources
  ];

  buildInputs = [
    libintl
    libiconv
    json-glib
  ];

  propagatedBuildInputs = [
    glib
    gtk3
  ];

  nativeCheckInputs = [
    xvfb-run
  ];

  # Tests fail in the Nix sandbox due to dbus-daemon initialization issues
  doCheck = false;

  mesonFlags = [
    "-Ddocs=disabled" # docs do not seem to be installed
  ];

  checkPhase = ''
    export NO_AT_BRIDGE=1
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus}/share/dbus-1/session.conf \
      meson test --print-errorlogs
  '';

  passthru = {
    updateScript = gitUpdater { };
    tests = {
      inherit zathura;
    };
  };

  meta = {
    homepage = "https://pwmt.org/projects/girara";
    description = "User interface library";
    longDescription = ''
      girara is a library that implements a GTK based VIM-like user interface
      that focuses on simplicity and minimalism.
    '';
    license = lib.licenses.zlib;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [ ];
  };
})
