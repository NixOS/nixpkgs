{ stdenv, fetchFromGitHub, pkgconfig, makeWrapper, makeDesktopItem
, ncurses, libtermkey, lua
, acl ? null, libselinux ? null
}:

let
  luaEnv = lua.withPackages(ps: [ps.lpeg]);
in
stdenv.mkDerivation rec {
  pname = "vis";
  version  = "0.5";

  src = fetchFromGitHub {
    rev = "v${version}";
    sha256 = "1vhq6hprkgj90iwl5vl3pxs3xwc01mx8yhi6c1phzry5agqqp8jb";
    repo = "vis";
    owner = "martanne";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper ];

  buildInputs = [
    ncurses
    libtermkey
    luaEnv
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    acl
    libselinux
  ];

  postPatch = ''
    patchShebangs ./configure
  '';


  postInstall = ''
    mkdir -p "$out/share/applications"
    cp $desktopItem/share/applications/* $out/share/applications
    echo wrapping $out/bin/vis with runtime environment
    wrapProgram $out/bin/vis \
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
