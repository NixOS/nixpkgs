{ lib, stdenv, fetchurl, meson, ninja, pkg-config, check, dbus, xvfb-run, glib, gtk, gettext, libiconv, json_c, libintl
}:

stdenv.mkDerivation rec {
  pname = "girara";
  version = "0.3.7";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://git.pwmt.org/pwmt/${pname}/-/archive/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-QTQiE/jnRSWPHbKMu2zMJ6YwCaXgAb95G74BzkNtTbc=";
  };

  nativeBuildInputs = [ meson ninja pkg-config gettext check dbus ];
  buildInputs = [ libintl libiconv json_c ];
  propagatedBuildInputs = [ glib gtk ];
  nativeCheckInputs = [ xvfb-run ];

  doCheck = !stdenv.isDarwin;

  mesonFlags = [
    "-Ddocs=disabled" # docs do not seem to be installed
  ];

  checkPhase = ''
    export NO_AT_BRIDGE=1
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus}/share/dbus-1/session.conf \
      meson test --print-errorlogs
  '';

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
