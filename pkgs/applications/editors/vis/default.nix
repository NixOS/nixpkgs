{ stdenv, fetchFromGitHub, unzip, pkgconfig, makeWrapper, ncurses, libtermkey, lpeg, lua }:

stdenv.mkDerivation rec {
  name = "vis-nightly-${version}";
  version = "2016-04-15";

  src = fetchFromGitHub {
    sha256 = "0a4gpwniy5r9dpfq51fxjxxnxavdjv8x76w9bbjnbnh8n63p3sj7";
    rev = "472c559a273d3c7b0f5ee92260c5544bc3d74576";
    repo = "vis";
    owner = "martanne";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
     unzip
     pkgconfig
     ncurses
     libtermkey
     lua
     lpeg
  ];

  LUA_CPATH="${lpeg}/lib/lua/${lua.luaversion}/?.so;";
  LUA_PATH="${lpeg}/share/lua/${lua.luaversion}/?.lua";

  postInstall = ''
    echo wrapping $out/bin/vis with runtime environment
    wrapProgram $out/bin/vis \
      --prefix LUA_CPATH : "${lpeg}/lib/lua/${lua.luaversion}/?.so" \
      --prefix LUA_PATH : "${lpeg}/share/lua/${lua.luaversion}/?.lua" \
      --prefix VIS_PATH : "$out/share/vis"
  '';

  meta = {
    description = "A vim like editor";
    homepage = http://github.com/martanne/vis;
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.vrthra ];
  };
}

