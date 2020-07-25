{ stdenv
, fetchFromGitHub
, SDL2
, lua52Packages
, pkg-config
, makeWrapper
} :

stdenv.mkDerivation rec {
  pname = "lite";
  version = "1.06";

  src = fetchFromGitHub {
    owner = "rxi";
    repo = pname;
    rev = "v${version}";
    sha256 = "1lw4a6xv8pdlgwnhh870caij4iyzxdyjw4qmm4fswja9mbqkj32f";
  };

  nativeBuildInputs = [ makeWrapper pkg-config ];

  buildInputs = [ SDL2 lua52Packages.lua ];

  postPatch = ''
    # use system Lua 5.2
    rm -rf src/lib/lua52
    substituteInPlace src/api/api.h \
      --replace '"lib/lua52/lua.h"' '<lua.h>' \
      --replace '"lib/lua52/lauxlib.h"' '<lauxlib.h>' \
      --replace '"lib/lua52/lualib.h"' '<lualib.h>'
  '';

  buildPhase = ''
    # extracted and adapted from build.sh
    CC=$NIX_CC/bin/cc
    CFLAGS="-Wall -O3 -g -std=gnu11 -Isrc -DLUA_USE_POPEN $(pkg-config --cflags lua sdl2)"
    LDFLAGS="$(pkg-config --libs lua sdl2)"
    for f in $(find src -name "*.c"); do
      $CC -c $CFLAGS $f -o "''${f//\//_}.o"
    done
    $CC *.o $LDFLAGS -o lite
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib/${pname}
    cp -a lite $out/lib/${pname}
    cp -a data $out/lib/${pname}
    makeWrapper $out/lib/${pname}/lite $out/bin/lite
  '';

  meta = with stdenv.lib; {
    description = "A lightweight text editor written in Lua";
    homepage = "https://github.com/rxi/lite";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.unix;
  };
}
