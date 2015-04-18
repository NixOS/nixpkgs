{ fetchurl, stdenv, which, pkgconfig, makeWrapper, libxcb, xcbutilkeysyms
, xcbutil, xcbutilwm, libstartup_notification, libX11, pcre, libev, yajl
, xcb-util-cursor, coreutils, perl, pango, perlPackages, xdummy, libxkbcommon }:

stdenv.mkDerivation rec {
  name = "i3-${version}";
  version = "4.9.1";

  src = fetchurl {
    url = "http://i3wm.org/downloads/${name}.tar.bz2";
    sha256 = "0hyw2rdxigiklqvv7fbhcdqdxkgcxvx56vk4r5v55l674zqfy3dp";
  };

  buildInputs = [
    which pkgconfig makeWrapper libxcb xcbutilkeysyms xcbutil xcbutilwm libxkbcommon
    libstartup_notification libX11 pcre libev yajl xcb-util-cursor perl pango
    perlPackages.AnyEventI3 perlPackages.X11XCB perlPackages.IPCRun
    perlPackages.ExtUtilsPkgConfig perlPackages.TestMore perlPackages.InlineC
  ];

  postPatch = ''
    patchShebangs .
  '';

  doCheck = stdenv.system == "x86_64-linux";

  checkPhase = stdenv.lib.optionalString (stdenv.system == "x86_64-linux")
  ''
    ln -sf "${xdummy}/bin/xdummy" testcases/Xdummy
    (cd testcases && perl complete-run.pl -p 1)
    ! grep -q '^not ok' testcases/latest/complete-run.log
  '';

  configurePhase = "makeFlags=PREFIX=$out";

  postInstall = ''
    wrapProgram "$out/bin/i3-save-tree" --prefix PERL5LIB ":" "$PERL5LIB"
    mkdir -p $out/man/man1
    cp man/*.1 $out/man/man1
    for program in $out/bin/i3-sensible-*; do
      sed -i 's/which/command -v/' $program
    done
  '';

  meta = with stdenv.lib; {
    description = "A tiling window manager";
    homepage    = "http://i3wm.org";
    maintainers = with maintainers; [ garbas modulistic ];
    license     = licenses.bsd3;
    platforms   = platforms.all;

    longDescription = ''
      A tiling window manager primarily targeted at advanced users and
      developers. Based on a tree as data structure, supports tiling,
      stacking, and tabbing layouts, handled dynamically, as well as
      floating windows. Configured via plain text file. Multi-monitor.
      UTF-8 clean.
    '';
  };

}

