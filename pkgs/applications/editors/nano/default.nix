{ stdenv, fetchurl, ncurses, gettext }:

stdenv.mkDerivation (rec {
  pname = "nano";
  version = "2.3.6";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnu/nano/${name}.tar.gz";
    sha256 = "a74bf3f18b12c1c777ae737c0e463152439e381aba8720b4bc67449f36a09534";
  };

  buildInputs = [ ncurses gettext ];

  configureFlags = "sysconfdir=/etc";

  meta = {
    homepage = http://www.nano-editor.org/;
    description = "A small, user-friendly console text editor";
  };
})
