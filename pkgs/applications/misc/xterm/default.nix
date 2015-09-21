{ stdenv, fetchurl, xorg, ncurses, freetype, fontconfig, pkgconfig }:

stdenv.mkDerivation rec {
  name = "xterm-320";

  src = fetchurl {
    url = "ftp://invisible-island.net/xterm/${name}.tgz";
    sha256 = "19r4rs5pjq944m7aiqligazf6wgmv4f023x3bx183h1l8dbvn3d6";
  };

  buildInputs =
    [ xorg.libXaw xorg.xproto xorg.libXt xorg.libXext xorg.libX11 xorg.libSM xorg.libICE
      ncurses freetype fontconfig pkgconfig xorg.libXft xorg.luit
    ];

  configureFlags = [
    "--enable-wide-chars"
    "--enable-256-color"
    "--enable-load-vt-fonts"
    "--enable-i18n"
    "--enable-doublechars"
    "--enable-luit"
    "--enable-mini-luit"
    "--with-tty-group=tty"
  ];

  # Work around broken "plink.sh".
  NIX_LDFLAGS = "-lXmu -lXt -lICE -lX11 -lfontconfig";

  # Hack to get xterm built with the feature of releasing a possible setgid of 'utmp',
  # decided by the sysadmin to allow the xterm reporting to /var/run/utmp
  # If we used the configure option, that would have affected the xterm installation,
  # (setgid with the given group set), and at build time the environment even doesn't have
  # groups, and the builder will end up removing any setgid.
  postConfigure = ''
    echo '#define USE_UTMP_SETGID 1'
  '';

  meta = {
    homepage = http://invisible-island.net/xterm;
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
