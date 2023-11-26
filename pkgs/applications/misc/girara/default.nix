{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, check
, dbus
, xvfb-run
, glib
, gtk
, gettext
, libiconv
, json-glib
, libintl
, zathura
}:

stdenv.mkDerivation rec {
  pname = "girara";
  version = "0.4.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitLab {
    domain = "git.pwmt.org";
    owner = "pwmt";
    repo = "girara";
    rev = version;
    sha256 = "sha256-dzWdiFGJ45JcH+wNwq2P3NZeWwHXAvXR1eJC85mYy7M=";
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
    gtk
  ];

  nativeCheckInputs = [
    xvfb-run
  ];

  doCheck = !stdenv.isDarwin;

  mesonFlags = [
    "-Ddocs=disabled" # docs do not seem to be installed
    (lib.mesonEnable "tests" (stdenv.buildPlatform.canExecute stdenv.hostPlatform))
  ];

  checkPhase = ''
    export NO_AT_BRIDGE=1
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus}/share/dbus-1/session.conf \
      meson test --print-errorlogs
  '';

  passthru.tests = {
    inherit zathura;
  };

  meta = with lib; {
    homepage = "https://git.pwmt.org/pwmt/girara";
    description = "User interface library";
    longDescription = ''
      girara is a library that implements a GTK based VIM-like user interface
      that focuses on simplicity and minimalism.
    '';
    license = licenses.zlib;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ ];
  };
}
