{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, expat
, gettext
, gtk
, libconfuse
, pcre2
, vte
, makeWrapper
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "tilda";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "lanoxx";
    repo = "tilda";
    rev = "${pname}-${version}";
    sha256 = "sha256-uDx28jmjNUyzJbgTJiHbjI9U5mYb9bnfl/9AjbxNUWA=";
  };

  nativeBuildInputs = [ autoreconfHook makeWrapper pkg-config ];
  buildInputs = [
    gettext
    gtk
    libconfuse
    pcre2
    vte
  ];

  LD_LIBRARY_PATH = "${expat.out}/lib"; # ugly hack for xgettext to work during build

  # The config locking scheme relies on the binary being called "tilda",
  # (`pgrep -C tilda`), so a simple `wrapProgram` won't suffice:
  postInstall = ''
    mkdir $out/bin/wrapped
    mv "$out/bin/tilda" "$out/bin/wrapped/tilda"
    makeWrapper "$out/bin/wrapped/tilda" "$out/bin/tilda" \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  passthru.tests.test = nixosTests.terminal-emulators.tilda;

  meta = with lib; {
    description = "A Gtk based drop down terminal for Linux and Unix";
    homepage = "https://github.com/lanoxx/tilda/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}

