{ stdenv, fetchFromGitHub, pkgconfig
, autoreconfHook, gettext, expat, pcre2
, libconfuse, vte, gtk
, makeWrapper }:

with stdenv.lib;
stdenv.mkDerivation rec {

  pname = "tilda";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "lanoxx";
    repo = "tilda";
    rev = "${pname}-${version}";
    sha256 = "0psq0f4s0s92bba6wwcf6b0j7i59b76svqxhvpavwv53yvhmmamn";
  };

  nativeBuildInputs = [ autoreconfHook makeWrapper pkgconfig ];
  buildInputs = [ gettext pcre2 libconfuse vte gtk ];

  LD_LIBRARY_PATH = "${expat.out}/lib"; # ugly hack for xgettext to work during build

  # The config locking scheme relies on the binary being called "tilda",
  # (`pgrep -C tilda`), so a simple `wrapProgram` won't suffice:
  postInstall = ''
    mkdir $out/bin/wrapped
    mv "$out/bin/tilda" "$out/bin/wrapped/tilda"
    makeWrapper "$out/bin/wrapped/tilda" "$out/bin/tilda" \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = {
    description = "A Gtk based drop down terminal for Linux and Unix";
    homepage = "https://github.com/lanoxx/tilda/";
    license = licenses.gpl3;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}

