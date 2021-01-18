{ lib, stdenv, fetchurl, ncurses
, patches ? [] # allow users to easily override config.def.h
}:

stdenv.mkDerivation rec {
  pname = "sacc";
  version = "1.02";

  src = fetchurl {
    url = "ftp://bitreich.org/releases/sacc/sacc-${version}.tgz";
    sha512 = "18ja95cscgjaj1xqn70dj0482f76d0561bdcc47flqfsjh4mqckjqr65qv7awnw6rzm03i5cp45j1qx12y0y83skgsar4pplmy8q014";
  };

  inherit patches;

  buildInputs = [ ncurses ];

  postPatch = ''
    substituteInPlace config.mk \
      --replace curses ncurses \
      --replace "/usr/local" "$out"
    '';

  meta = with lib; {
    description = "A terminal gopher client";
    homepage = "gopher://bitreich.org/1/scm/sacc";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
    platforms = platforms.unix;
  };
}
