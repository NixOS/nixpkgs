{ fetchurl, stdenv, which, pkgconfig, makeWrapper, libxcb, xcbutilkeysyms
, xcbutil, xcbutilwm, libstartup_notification, libX11, pcre, libev, yajl
, xcb-util-cursor, coreutils, perl, pango, perlPackages, libxkbcommon
, xorgserver, xvfb_run, dmenu, i3status }:

stdenv.mkDerivation rec {
  name = "i3-${version}";
  version = "4.12";

  src = fetchurl {
    url = "http://i3wm.org/downloads/${name}.tar.bz2";
    sha256 = "1d3q3lgpjbkmcwzjhp0dfr0jq847silcfg087slcnj95ikh1r7p1";
  };

  buildInputs = [
    which pkgconfig makeWrapper libxcb xcbutilkeysyms xcbutil xcbutilwm libxkbcommon
    libstartup_notification libX11 pcre libev yajl xcb-util-cursor perl pango
    perlPackages.AnyEventI3 perlPackages.X11XCB perlPackages.IPCRun
    perlPackages.ExtUtilsPkgConfig perlPackages.TestMore perlPackages.InlineC
    xorgserver xvfb_run
  ];

  postPatch = ''
    patchShebangs .
  '';

  postFixup = ''
    substituteInPlace $out/etc/i3/config --replace dmenu_run ${dmenu}/bin/dmenu_run
    substituteInPlace $out/etc/i3/config --replace "status_command i3status" "status_command ${i3status}/bin/i3status"
    substituteInPlace $out/etc/i3/config.keycodes --replace dmenu_run ${dmenu}/bin/dmenu_run
    substituteInPlace $out/etc/i3/config.keycodes --replace "status_command i3status" "status_command ${i3status}/bin/i3status"
  '';

  # Tests have been failing (at least for some people in some cases)
  # and have been disabled until someone wants to fix them. Some
  # initial digging uncovers that the tests call out to `git`, which
  # they shouldn't, and then even once that's fixed have some
  # perl-related errors later on. For more, see
  # https://github.com/NixOS/nixpkgs/issues/7957
  doCheck = false; # stdenv.system == "x86_64-linux";

  checkPhase = stdenv.lib.optionalString (stdenv.system == "x86_64-linux")
  ''
    (cd testcases && xvfb-run ./complete-run.pl -p 1 --keep-xserver-output)
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
