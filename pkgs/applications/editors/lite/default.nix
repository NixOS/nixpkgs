{ lib, stdenv
, fetchFromGitHub
, SDL2
, lua52Packages
, pkg-config
, makeWrapper
, openlibm
} :

stdenv.mkDerivation rec {
  pname = "lite";
  version = "1.11";

  src = fetchFromGitHub {
    owner = "rxi";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wxqfb4ly8g7w5qph76xys95b55ackkags8jgd1nasmiyi8gcd5a";
  };

  nativeBuildInputs = [ makeWrapper pkg-config ];

  buildInputs = [ SDL2 lua52Packages.lua openlibm ];

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
    LDFLAGS="$(pkg-config --libs lua sdl2 openlibm)"
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

  meta = with lib; {
    description = "A lightweight text editor written in Lua";
    homepage = "https://github.com/rxi/lite";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
    platforms = platforms.unix;
    mainProgram = "lite";
  };
}
