{ fetchurl, lib, stdenv, pkg-config, makeWrapper, meson, ninja, installShellFiles, libxcb, xcbutilkeysyms
, xcbutil, xcbutilwm, xcbutilxrm, libstartup_notification, libX11, pcre2, libev
, yajl, xcb-util-cursor, perl, pango, perlPackages, libxkbcommon
, xorgserver, xvfb-run
, asciidoc, xmlto, docbook_xml_dtd_45, docbook_xsl, findXMLCatalogs
}:

stdenv.mkDerivation rec {
  pname = "i3";
  version = "4.23";

  src = fetchurl {
    url = "https://i3wm.org/downloads/${pname}-${version}.tar.xz";
    sha256 = "sha256-YQJqcZbJE50POq3ScZfosyDFduOkUOAddMGspIQETEY=";
  };

  nativeBuildInputs = [
    pkg-config makeWrapper meson ninja installShellFiles perl
    asciidoc xmlto docbook_xml_dtd_45 docbook_xsl findXMLCatalogs
  ];

  mesonFlags = [
    "-Ddocs=true"
    "-Dmans=true"
  ];

  buildInputs = [
    libxcb xcbutilkeysyms xcbutil xcbutilwm xcbutilxrm libxkbcommon
    libstartup_notification libX11 pcre2 libev yajl xcb-util-cursor perl pango
    perlPackages.AnyEventI3 perlPackages.X11XCB perlPackages.IPCRun
    perlPackages.ExtUtilsPkgConfig perlPackages.InlineC
    xorgserver xvfb-run
  ];

  configureFlags = [ "--disable-builddir" ];

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

  checkPhase = lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux")
  ''
    (cd testcases && xvfb-run ./complete-run.pl -p 1 --keep-xserver-output)
    ! grep -q '^not ok' testcases/latest/complete-run.log
  '';

  postInstall = ''
    wrapProgram "$out/bin/i3-save-tree" --prefix PERL5LIB ":" "$PERL5LIB"
    for program in $out/bin/i3-sensible-*; do
      sed -i 's/which/command -v/' $program
    done

    installManPage man/*.1
  '';

  separateDebugInfo = true;

  meta = with lib; {
    description = "Tiling window manager";
    homepage    = "https://i3wm.org";
    maintainers = with maintainers; [ modulistic fpletz ];
    mainProgram = "i3";
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
