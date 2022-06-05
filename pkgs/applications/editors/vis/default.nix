{ lib, stdenv, fetchFromGitHub, pkg-config, makeWrapper
, copyDesktopItems, makeDesktopItem
, ncurses, libtermkey, lua, tre
, acl, libselinux
}:

let
  luaEnv = lua.withPackages(ps: [ ps.lpeg ]);
in
stdenv.mkDerivation rec {
  pname = "vis";
  version  = "0.7";

  src = fetchFromGitHub {
    rev = "v${version}";
    sha256 = "1g05ncsnk57kcqm9wsv6sz8b24kyzj8r5rfpa1wfwj8qkjzx3vji";
    repo = "vis";
    owner = "martanne";
  };

  nativeBuildInputs = [ pkg-config makeWrapper copyDesktopItems ];

  buildInputs = [
    ncurses
    libtermkey
    luaEnv
    tre
  ] ++ lib.optionals stdenv.isLinux [
    acl
    libselinux
  ];

  postPatch = ''
    patchShebangs ./configure
  '';

  postInstall = ''
    wrapProgram $out/bin/vis \
      --prefix LUA_CPATH ';' "${luaEnv}/lib/lua/${lua.luaversion}/?.so" \
      --prefix LUA_PATH ';' "${luaEnv}/share/lua/${lua.luaversion}/?.lua" \
      --prefix VIS_PATH : "\$HOME/.config:$out/share/vis"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "vis";
      exec = "vis %U";
      type = "Application";
      icon = "accessories-text-editor";
      comment = meta.description;
      desktopName = "vis";
      genericName = "Text editor";
      categories = [ "Application" "Development" "IDE" ];
      mimeTypes = [ "text/plain" "application/octet-stream" ];
      startupNotify = false;
      terminal = true;
    })
  ];

  meta = with lib; {
    description = "A vim like editor";
    homepage = "https://github.com/martanne/vis";
    license = licenses.isc;
    maintainers = with maintainers; [ vrthra ramkromberg ];
    platforms = platforms.unix;
  };
}
