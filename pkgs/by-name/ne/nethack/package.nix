{
  stdenv,
  lib,
  fetchurl,
  coreutils,
  gnugrep,
  ncurses,
  gzip,
  gccStdenv,
  less,
  pkg-config,
  buildPackages,
  x11Mode ? false,
  qtMode ? false,
  libxaw,
  libxext,
  libxpm,
  libxmu,
  libxt,
  libx11,
  bdftopcf,
  mkfontdir,
  xset,
  font-misc-misc,
  font-adobe-75dpi,
  qt5,
  copyDesktopItems,
  makeDesktopItem,
}:

let
  stdenvUsed = if qtMode then gccStdenv else stdenv;

  # NetHack 5.0 builds its own copy of Lua (normally a git submodule or fetched
  # via 'make fetch-lua'); the version is pinned in sys/unix/Makefile.top.
  luaVersion = "5.4.8";
  luaSrc = fetchurl {
    url = "https://www.lua.org/ftp/lua-${luaVersion}.tar.gz";
    hash = "sha256-TxjdrhVOeT5G7qtyfFnvHAwMK3ROe5QhlxDXb1MGKa4=";
  };

  platform =
    if stdenvUsed.hostPlatform.isUnix then
      "unix"
    else
      throw "Unknown platform for NetHack: ${stdenvUsed.hostPlatform.system}";
  # As of 5.0 a single hints file covers all the Unix window ports; the window
  # system is selected with WANT_WIN_* make variables instead.
  unixHint =
    if stdenvUsed.hostPlatform.isLinux then
      "linux.500"
    else if stdenvUsed.hostPlatform.isDarwin then
      "macOS.500"
    else
      "unix";
  userDir = "~/.config/nethack";
  binPath = lib.makeBinPath [
    coreutils
    less
  ];

  x11FontPath = lib.concatStringsSep "," [
    "${font-misc-misc}/share/fonts/X11/misc"
    "${font-adobe-75dpi}/share/fonts/X11/75dpi"
  ];

  isCross = stdenvUsed.buildPlatform != stdenvUsed.hostPlatform;

in
stdenvUsed.mkDerivation (finalAttrs: {
  version = "5.0.0";
  pname =
    if x11Mode then
      "nethack-x11"
    else if qtMode then
      "nethack-qt"
    else
      "nethack";

  src = fetchurl {
    url = "https://nethack.org/download/${finalAttrs.version}/nethack-${
      lib.replaceStrings [ "." ] [ "" ] finalAttrs.version
    }-src.tgz";
    hash = "sha256-KVm3iGqsdhhbkK6gyfgNFDQ/YE3grpaz3Sp2D3qzvek=";
  };

  buildInputs = [
    ncurses
  ]
  ++ lib.optionals x11Mode [
    libxaw
    libxext
    libxpm
    libxmu
    libxt
    libx11
  ]
  ++ lib.optionals qtMode [
    gzip
    qt5.qtbase
    qt5.qtmultimedia
  ];

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
  ]
  ++ lib.optionals x11Mode [
    mkfontdir
    bdftopcf
  ]
  ++ lib.optionals qtMode [
    mkfontdir
    bdftopcf
    qt5.wrapQtAppsHook
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "CC=${stdenvUsed.cc.targetPrefix}cc"
    # The build embeds the current git revision into the version string; there
    # is no repository in the source tarball, so blank these out to avoid
    # capturing git's error message.
    "GITHASH="
    "GITBRANCH="
    "GITPREFIX="
  ]
  ++ (
    if x11Mode then
      [
        "WANT_WIN_TTY=1"
        "WANT_WIN_X11=1"
        "WANT_DEFAULT=X11"
      ]
    else if qtMode then
      [
        "WANT_WIN_QT=1"
        "WANT_WIN_QT5=1"
        "WANT_DEFAULT=Qt"
        "MOCPATH=${qt5.qtbase.dev}/bin/moc"
      ]
    else
      [
        "WANT_WIN_TTY=1"
        "WANT_WIN_CURSES=1"
        "WANT_DEFAULT=curses"
      ]
  );

  postPatch = ''
    # Provide the Lua source tree the build expects.
    mkdir -p lib
    tar -xzf ${luaSrc} -C lib
    chmod -R u+w lib/lua-${luaVersion}

    # NetHack's Makefile.top forwards CC to the bundled Lua build (LUAMAKEFLAGS)
    # but not AR/RANLIB, so Lua's src/Makefile uses a bare `ar`/`ranlib` that
    # doesn't exist under cross. Point them at the (possibly prefixed) toolchain;
    # targetPrefix is empty for native builds, so this is a no-op there.
    sed -e 's,^AR= ar,AR= ${stdenvUsed.cc.targetPrefix}ar,' \
      -e 's,^RANLIB= ranlib,RANLIB= ${stdenvUsed.cc.targetPrefix}ranlib,' \
      -i lib/lua-${luaVersion}/src/Makefile

    # Same thing for nethack itself.
    sed -e 's,^AR = ar$,AR = ${stdenvUsed.cc.targetPrefix}ar,' \
      -i sys/unix/Makefile.src

    sed -e '/^ *cd /d' -i sys/unix/nethack.sh

    # Use gzip from nixpkgs for save/bones compression.
    sed -e 's,/bin/gzip,${gzip}/bin/gzip,g' \
      -i sys/unix/hints/linux.500 sys/unix/hints/macOS.500

    # The launcher runs the game from a private rundir populated with symlinks,
    # so we don't want nethack to chdir into HACKDIR.
    sed -e '/define CHDIR/d' -i include/config.h

    # Point the runtime sysconf at a grep that exists in the store. GDBPATH is
    # already disabled by the hint's POSTINSTALL step when /usr/bin/gdb is absent.
    sed -e 's,^GREPPATH=.*,GREPPATH=${gnugrep}/bin/grep,' -i sys/unix/sysconf
    ${lib.optionalString qtMode ''
      # Let pkg-config use the environment search path set up by nix rather than
      # the hard-coded QTDIR.
      sed -e 's,PKG_CONFIG_PATH=$(QTDIR)/lib/pkgconfig ,,g' \
        -i sys/unix/hints/linux.500
    ''}
    ${lib.optionalString isCross
      # If we're cross-compiling, replace the paths to the data generation tools
      # with the ones from the build platform's nethack package, since we can't
      # run the ones we've built here.
      ''
        ${buildPackages.perl}/bin/perl -p \
          -e 's,[a-z./]+/(makedefs|dlb)(?!\.),${buildPackages.nethack}/libexec/nethack/\1,g' \
          -i sys/unix/Makefile.*

        # 5.0.0's Makefile.src force-rebuilds makedefs: it `rm -f $(MAKEDEFS)`s
        # after monst.o/objects.o and has a `$(MAKEDEFS):` rule that recompiles
        # it. With MAKEDEFS pointing at the read-only, build-platform binary
        # above, the rm fails ("Permission denied") and a recompile would target
        # the wrong arch. Under cross we use the prebuilt one as-is, so drop the
        # rm and stub the rebuild recipe.
        sed -e '/rm -f $(MAKEDEFS)/d' \
          -e 's,$(MAKE) makedefs ),true ),' \
          -i sys/unix/Makefile.src
      ''
    }
  '';

  configurePhase = ''
    runHook preConfigure
    pushd sys/${platform}
    ${lib.optionalString (platform == "unix") ''
      sh setup.sh hints/${unixHint}
    ''}
    popd
    runHook postConfigure
  '';

  # https://github.com/NixOS/nixpkgs/issues/294751
  enableParallelBuilding = false;

  preFixup = lib.optionalString qtMode ''
    wrapQtApp "$out/games/nethack"
  '';

  postInstall = ''
    mkdir -p $out/games/lib/nethackuserdir
    for i in xlogfile logfile perm record save; do
      mv $out/games/lib/nethackdir/$i $out/games/lib/nethackuserdir
    done

    mkdir -p $out/bin
    cat <<EOF >$out/bin/nethack
    #! ${stdenvUsed.shell} -e
    PATH=${binPath}:\$PATH

    if [ ! -d ${userDir} ]; then
      mkdir -p ${userDir}
      cp -r $out/games/lib/nethackuserdir/* ${userDir}
      chmod -R +w ${userDir}
    fi

    RUNDIR=\$(mktemp -d)

    cleanup() {
      rm -rf \$RUNDIR${lib.optionalString x11Mode ''

        ${xset}/bin/xset -fp ${x11FontPath} >/dev/null 2>&1 || true''}
    }
    trap cleanup EXIT
    ${lib.optionalString x11Mode ''
      ${xset}/bin/xset +fp ${x11FontPath} >/dev/null 2>&1 || true
      ${xset}/bin/xset fp rehash >/dev/null 2>&1 || true
    ''}
    cd \$RUNDIR
    for i in ${userDir}/*; do
      ln -s \$i \$(basename \$i)
    done
    for i in $out/games/lib/nethackdir/*; do
      ln -s \$i \$(basename \$i)
    done
    set +e
    $out/games/nethack "\$@"
    if [[ \$? -gt 128 ]]; then
      echo "nethack exited abnormally, attempting to recover save file..."
      ./recover -d . ?lock.0
    fi
    EOF
    chmod +x $out/bin/nethack
    ${lib.optionalString x11Mode "mv $out/bin/nethack $out/bin/nethack-x11"}
    ${lib.optionalString qtMode "mv $out/bin/nethack $out/bin/nethack-qt"}
    install -Dm 555 util/makedefs -t $out/libexec/nethack/
    ${lib.optionalString (!(x11Mode || qtMode)) "install -Dm 555 util/dlb -t $out/libexec/nethack/"}
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "NetHack";
      exec =
        if x11Mode then
          "nethack-x11"
        else if qtMode then
          "nethack-qt"
        else
          "nethack";
      icon = "nethack";
      desktopName = "NetHack";
      comment = "NetHack is a single player dungeon exploration game";
      categories = [
        "Game"
        "ActionGame"
      ];
    })
  ];

  meta = {
    description = "Rogue-like game";
    homepage = "http://nethack.org/";
    license = lib.licenses.ngpl;
    platforms = if x11Mode then lib.platforms.linux else lib.platforms.unix;
    maintainers = with lib.maintainers; [ olduser101 ];
    mainProgram = "nethack";
    broken = if qtMode then stdenv.hostPlatform.isDarwin else false;
  };
})
