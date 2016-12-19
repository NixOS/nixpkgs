{ stdenv, fetchFromGitHub, pkgconfig, makeWrapper, makeDesktopItem
, ncurses, libtermkey, lpeg, lua
, acl ? null, libselinux ? null
, version ? "2016-10-09"
, rev ? "b0c9b0063d0b9ed9a7f93c69779749130b353ff1"
, sha256 ? "0g3242g3r2w38ld3w71f79qp7zzy3zhanff2nhwkwmyq89js8s90"
}:

stdenv.mkDerivation rec {
  name = "vis-unstable-${version}";
  inherit version;

  src = fetchFromGitHub {
    inherit sha256;
    inherit rev;
    repo = "vis";
    owner = "martanne";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper ];

  buildInputs = [
    ncurses
    libtermkey
    lua
    lpeg
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    acl
    libselinux
  ];

  LUA_CPATH="${lpeg}/lib/lua/${lua.luaversion}/?.so;";
  LUA_PATH="${lpeg}/share/lua/${lua.luaversion}/?.lua";

  postInstall = ''
    mkdir -p "$out/share/applications"
    cp $desktopItem/share/applications/* $out/share/applications
    echo wrapping $out/bin/vis with runtime environment
    wrapProgram $out/bin/vis \
      --prefix LUA_CPATH : "${lpeg}/lib/lua/${lua.luaversion}/?.so" \
      --prefix LUA_PATH : "${lpeg}/share/lua/${lua.luaversion}/?.lua" \
      --prefix VIS_PATH : "\$HOME/.config:$out/share/vis"
  '';

  desktopItem = makeDesktopItem rec {
    name = "vis";
    exec = "vis %U";
    type = "Application";
    icon = "accessories-text-editor";
    comment = meta.description;
    desktopName = "vis";
    genericName = "Text editor";
    categories = stdenv.lib.concatStringsSep ";" [
      "Application" "Development" "IDE"
    ];
    mimeType = stdenv.lib.concatStringsSep ";" [
      "text/plain" "application/octet-stream"
    ];
    startupNotify = "false";
    terminal = "true";
  };

  meta = with stdenv.lib; {
    description = "A vim like editor";
    homepage = http://github.com/martanne/vis;
    license = licenses.isc;
    maintainers = with maintainers; [ vrthra ramkromberg ];
    platforms = platforms.unix;
  };
}
