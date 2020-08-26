{ stdenv, fetchgit, ncurses
, patches ? [] # allow users to easily override config.def.h
}:

stdenv.mkDerivation rec {
  pname = "sacc";
  version = "1.01";

  src = fetchgit {
    url = "git://bitreich.org/sacc";
    rev = version;
    sha256 = "0n6ghbi715m7hrxzqggx1bpqj8h7569s72b9bzk6m4gd29jaq9hz";
  };

  inherit patches;

  buildInputs = [ ncurses ];

  postPatch = ''
    substituteInPlace config.mk \
      --replace curses ncurses \
      --replace "/usr/local" "$out"
    '';

  meta = with stdenv.lib; {
    description = "A terminal gopher client";
    homepage = "gopher://bitreich.org/1/scm/sacc";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
    platforms = platforms.unix;
  };
}
