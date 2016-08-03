{ stdenv, fetchFromGitHub, unzip, pkgconfig, makeWrapper
, ncurses, libtermkey, lpeg, lua
, acl ? null, libselinux ? null
, version ? "2016-07-15"
, rev ? "5c2cee9461ef1199f2e80ddcda699595b11fdf08"
, sha256 ? "1jmsv72hq0c2f2rnpllvd70cmxbjwfhynzwaxx24f882zlggwsnd"
}:

stdenv.mkDerivation rec {
  name = "vis-nightly-${version}";
  inherit version;

  src = fetchFromGitHub {
    inherit sha256;
    inherit rev;
    repo = "vis";
    owner = "martanne";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    unzip pkgconfig
    ncurses
    libtermkey
    lua
    lpeg
  ] ++ stdenv.lib.optional stdenv.isLinux [
    acl
    libselinux
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

  meta = with stdenv.lib; {
    description = "A vim like editor";
    homepage = http://github.com/martanne/vis;
    license = licenses.isc;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.unix;
  };
}
