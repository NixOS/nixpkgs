{ stdenv, fetchFromGitHub, pkgconfig, makeWrapper, makeDesktopItem
, ncurses, libtermkey, lpeg, lua
, acl ? null, libselinux ? null
}:

stdenv.mkDerivation rec {
  name = "vis-${version}";
  version  = "0.4";

  src = fetchFromGitHub {
    rev = "v${version}";
    sha256 = "1crsg3ssqv4xix9z16hwl0zyx7hxk686s52zmrp7yfak3m5igf9k";
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

  postPatch = ''
    patchShebangs ./configure
  '';

  LUA_CPATH="${lpeg}/lib/lua/${lua.luaversion}/?.so;";
  LUA_PATH="${lpeg}/share/lua/${lua.luaversion}/?.lua";

  postInstall = ''
    mkdir -p "$out/share/applications"
    cp $desktopItem/share/applications/* $out/share/applications
    echo wrapping $out/bin/vis with runtime environment
    wrapProgram $out/bin/vis \
      --prefix LUA_CPATH ';' "${lpeg}/lib/lua/${lua.luaversion}/?.so" \
      --prefix LUA_PATH ';' "${lpeg}/share/lua/${lua.luaversion}/?.lua" \
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
    homepage = https://github.com/martanne/vis;
    license = licenses.isc;
    maintainers = with maintainers; [ vrthra ramkromberg ];
    platforms = platforms.unix;
  };
}
