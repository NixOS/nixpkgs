{ fetchurl, stdenv, which, pkgconfig, makeWrapper, libxcb, xcbutilkeysyms
, xcbutil, xcbutilwm, xcbutilxrm, libstartup_notification, libX11, pcre, libev
, yajl, xcb-util-cursor, perl, pango, perlPackages, libxkbcommon
, xorgserver, xvfb_run }:

stdenv.mkDerivation rec {
  name = "i3-${version}";
  version = "4.16.1";

  src = fetchurl {
    url = "https://i3wm.org/downloads/${name}.tar.bz2";
    sha256 = "0xl56y196vxv001gvx35xwfr25zah8m3xwizp9ycdgdc0rfc4rdb";
  };

  nativeBuildInputs = [ which pkgconfig makeWrapper ];

  buildInputs = [
    libxcb xcbutilkeysyms xcbutil xcbutilwm xcbutilxrm libxkbcommon
    libstartup_notification libX11 pcre libev yajl xcb-util-cursor perl pango
    perlPackages.AnyEventI3 perlPackages.X11XCB perlPackages.IPCRun
    perlPackages.ExtUtilsPkgConfig perlPackages.InlineC
    xorgserver xvfb_run
  ];

  configureFlags = [ "--disable-builddir" ];

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs .
  '';

  # Tests have been failing (at least for some people in some cases)
  # and have been disabled until someone wants to fix them. Some
  # initial digging uncovers that the tests call out to `git`, which
  # they shouldn't, and then even once that's fixed have some
  # perl-related errors later on. For more, see
  # https://github.com/NixOS/nixpkgs/issues/7957
  doCheck = false; # stdenv.hostPlatform.system == "x86_64-linux";

  checkPhase = stdenv.lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux")
  ''
    (cd testcases && xvfb-run ./complete-run.pl -p 1 --keep-xserver-output)
    ! grep -q '^not ok' testcases/latest/complete-run.log
  '';

  postInstall = ''
    wrapProgram "$out/bin/i3-save-tree" --prefix PERL5LIB ":" "$PERL5LIB"
    for program in $out/bin/i3-sensible-*; do
      sed -i 's/which/command -v/' $program
    done

    install -vD -t $out/share/man/man1 man/*.{1,man}
  '';

  separateDebugInfo = true;

  meta = with stdenv.lib; {
    description = "A tiling window manager";
    homepage    = "https://i3wm.org";
    maintainers = with maintainers; [ garbas modulistic fpletz ];
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
