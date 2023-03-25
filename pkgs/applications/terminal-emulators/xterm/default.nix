{ lib, stdenv, fetchurl, fetchpatch, xorg, ncurses, freetype, fontconfig
, pkg-config, makeWrapper, nixosTests, gitUpdater
, nixfmt, nix, gnused, coreutils, enableDecLocator ? true }:

stdenv.mkDerivation rec {
  pname = "xterm";
  version = "379";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/xterm/${pname}-${version}.tgz"
      "https://invisible-mirror.net/archives/xterm/${pname}-${version}.tgz"
    ];
    hash = "sha256-p93ydO6EuX+xKDZ1AJ1Tyi0CoP/VzlpRGNr8NiPrsxA=";
  };

  strictDeps = true;

  nativeBuildInputs = [ makeWrapper pkg-config fontconfig ];

  buildInputs = [
    xorg.libXaw
    xorg.xorgproto
    xorg.libXt
    xorg.libXext
    xorg.libX11
    xorg.libSM
    xorg.libICE
    ncurses
    freetype
    xorg.libXft
    xorg.luit
  ];

  patches = [ ./sixel-256.support.patch ]
    ++ lib.optional stdenv.hostPlatform.isMusl (fetchpatch {
      name = "posix-ptys.patch";
      url =
        "https://git.alpinelinux.org/aports/plain/community/xterm/posix-ptys.patch?id=3aa532e77875fa1db18c7fcb938b16647031bcc1";
      sha256 = "0czgnsxkkmkrk1idw69qxbprh0jb4sw3c24zpnqq2v76jkl7zvlr";
    });

  configureFlags = [
    "--enable-wide-chars"
    "--enable-256-color"
    "--enable-sixel-graphics"
    "--enable-regis-graphics"
    "--enable-load-vt-fonts"
    "--enable-i18n"
    "--enable-doublechars"
    "--enable-luit"
    "--enable-mini-luit"
    "--with-tty-group=tty"
    "--with-app-defaults=$(out)/lib/X11/app-defaults"
  ] ++ lib.optional enableDecLocator "--enable-dec-locator";

  env = {
    # Work around broken "plink.sh".
    NIX_LDFLAGS = "-lXmu -lXt -lICE -lX11 -lfontconfig";
  } // lib.optionalAttrs stdenv.hostPlatform.isMusl {
    # Various symbols missing without this define: TAB3, NLDLY, CRDLY, BSDLY, FFDLY, CBAUD
    NIX_CFLAGS_COMPILE = "-D_GNU_SOURCE";
  };

  # Hack to get xterm built with the feature of releasing a possible setgid of 'utmp',
  # decided by the sysadmin to allow the xterm reporting to /var/run/utmp
  # If we used the configure option, that would have affected the xterm installation,
  # (setgid with the given group set), and at build time the environment even doesn't have
  # groups, and the builder will end up removing any setgid.
  postConfigure = ''
    echo '#define USE_UTMP_SETGID 1'
  '';

  postInstall = ''
    for bin in $out/bin/*; do
      wrapProgram $bin --set XAPPLRESDIR $out/lib/X11/app-defaults/
    done

    install -D -t $out/share/applications xterm.desktop
    install -D -t $out/share/icons/hicolor/48x48/apps icons/xterm-color_48x48.xpm
  '';

  passthru = {
    tests = {
      customTest = nixosTests.xterm;
      standardTest = nixosTests.terminal-emulators.xterm;
    };

    updateScript = gitUpdater {
      # No nicer place to find latest release.
      url = "https://github.com/ThomasDickey/xterm-snapshots.git";
      rev-prefix = "xterm-";
      # Tags that end in letters are unstable
      ignoredVersions = "[a-z]$";
    };
  };

  meta = {
    homepage = "https://invisible-island.net/xterm";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ nequissimus vrthra ];
    platforms = with lib.platforms; linux ++ darwin;
    changelog = "https://invisible-island.net/xterm/xterm.log.html";
  };
}
