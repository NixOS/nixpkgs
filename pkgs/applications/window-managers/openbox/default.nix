{ lib, stdenv, fetchurl, autoreconfHook, pkg-config, python3
, libxml2, libXinerama, libXcursor, libXau, libXrandr, libICE, libSM
, imlib2, pango, libstartup_notification, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "openbox";
  version = "3.6.1";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    makeWrapper
    python3.pkgs.wrapPython
  ];

  buildInputs = [
    libxml2
    libXinerama libXcursor libXau libXrandr libICE libSM
    libstartup_notification
    python3
  ];

  propagatedBuildInputs = [
    pango imlib2
  ];

  pythonPath = with python3.pkgs; [
    pyxdg
  ];

  src = fetchurl {
    url = "http://openbox.org/dist/openbox/${pname}-${version}.tar.gz";
    sha256 = "1xvyvqxlhy08n61rjkckmrzah2si1i7nmc7s8h07riqq01vc0jlb";
  };

  setlayoutSrc = fetchurl {
    url = "http://openbox.org/dist/tools/setlayout.c";
    sha256 = "1ci9lq4qqhl31yz1jwwjiawah0f7x0vx44ap8baw7r6rdi00pyiv";
  };

  patches = [
    # Use fetchurl to avoid "fetchpatch: ignores file renames" #32084
    # This patch adds python3 support
    (fetchurl {
      url = "https://git.archlinux.org/svntogit/community.git/plain/openbox/trunk/py3.patch?id=90cb57ef53d952bb6ab4c33a184f815bbe1791c0";
      sha256 = "1ks99awlkhd5ph9kz94s1r6m1bfvh42g4rmxd14dyg5b421p1ljc";
    })
  ];

  postBuild = "gcc -O2 -o setlayout $(pkg-config --cflags --libs x11) $setlayoutSrc";

  # Openbox needs XDG_DATA_DIRS set or it can't find its default theme
  postInstall = ''
    cp -a setlayout "$out"/bin
    wrapProgram "$out/bin/openbox" --prefix XDG_DATA_DIRS : "$out/share"
    wrapProgram "$out/bin/openbox-session" --prefix XDG_DATA_DIRS : "$out/share"
    wrapProgram "$out/bin/openbox-gnome-session" --prefix XDG_DATA_DIRS : "$out/share"
    wrapProgram "$out/bin/openbox-kde-session" --prefix XDG_DATA_DIRS : "$out/share"
    wrapPythonProgramsIn "$out/libexec" "$out $pythonPath"
  '';

  meta = {
    description = "X window manager for non-desktop embedded systems";
    homepage = "http://openbox.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
