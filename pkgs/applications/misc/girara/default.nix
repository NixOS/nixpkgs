{ stdenv, fetchurl, meson, ninja, pkgconfig, check, dbus, xvfb_run, glib, gtk, gettext, libiconv, json_c, libintl
}:

stdenv.mkDerivation rec {
  pname = "girara";
  version = "0.3.2";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://pwmt.org/projects/girara/download/${pname}-${version}.tar.xz";
    sha256 = "1kc6n1mxjxa7wvwnqy94qfg8l9jvx9qrvrr2kc7m4g0z20x3a00p";
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext check dbus xvfb_run ];
  buildInputs = [ libintl libiconv json_c ];
  propagatedBuildInputs = [ glib gtk ];

  doCheck = true;

  mesonFlags = [
    "-Ddocs=disabled" # docs do not seem to be installed
  ];

  checkPhase = ''
    export NO_AT_BRIDGE=1
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      meson test --print-errorlogs
  '';

  meta = with stdenv.lib; {
    homepage = https://pwmt.org/projects/girara/;
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
