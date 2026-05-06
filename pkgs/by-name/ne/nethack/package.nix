{
  stdenv,
  lib,
  fetchurl,
  coreutils,
  groff,
  ncurses,
  gzip,
  less,
  x11Mode ? false,
  qtMode ? false,
  libxaw,
  libxext,
  libxpm,
  bdftopcf,
  mkfontdir,
  pkg-config,
  qt5,
  copyDesktopItems,
  makeDesktopItem,
}:

let
  hint =
    if stdenv.hostPlatform.isLinux then
      "linux.500"
    else if stdenv.hostPlatform.isDarwin then
      "macos.500"
    else
      "unix";
  userDir = "~/.config/nethack";
  binPath = lib.makeBinPath [
    coreutils
    less
  ];
in

stdenv.mkDerivation (finalAttrs: {
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
    sha256 = "sha256-KVm3iGqsdhhbkK6gyfgNFDQ/YE3grpaz3Sp2D3qzvek=";
  };

  buildInputs = [
    ncurses
  ]
  ++ lib.optionals x11Mode [
    libxaw
    libxext
    libxpm
  ]
  ++ lib.optionals qtMode [
    gzip
    qt5.qtbase.bin
    qt5.qtmultimedia.bin
  ];

  nativeBuildInputs = [
    copyDesktopItems
    groff
    pkg-config
  ]
  ++ lib.optionals x11Mode [
    mkfontdir
    bdftopcf
  ]
  ++ lib.optionals qtMode [
    mkfontdir
    qt5.qtbase.dev
    qt5.qtmultimedia.dev
    qt5.wrapQtAppsHook
    bdftopcf
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "WANT_WIN_TTY=1"
    "WANT_WIN_CURSES=1"
    "WANT_DEFAULT=curses"
  ]
  ++ lib.optionals x11Mode [
    "WANT_WIN_X11=1"
    "WANT_DEFAULT=X11"
  ]
  ++ lib.optionals qtMode [
    "WANT_WIN_QT=1"
    "WANT_DEFAULT=Qt"
  ];

  postPatch = ''
    sed -e '/^ *cd /d' -i sys/unix/nethack.sh
    sed -e '/rm -f $(MAKEDEFS)/d' -i sys/unix/Makefile.src
    sed \
      -e 's,^CFLAGS=-g,CFLAGS=,' \
      -e 's,/bin/gzip,${gzip}/bin/gzip,g' \
      -e 's,^WINTTYLIB=.*,WINTTYLIB=-lncurses,' \
      -e 's,^QTDIR *=.*,QTDIR=${qt5.qtbase.dev},' \
      -e 's,PKG_CONFIG_PATH=$(QTDIR)/lib/pkgconfig,,' \
      -e 's,NHCFLAGS+=-DCOMPRESS[^ ]*,NHCFLAGS+=-DCOMPRESS=\\"${gzip}/bin/gzip\\" \\\
        -DCOMPRESS_EXTENSION=\\".gz\\",' \
      -i sys/unix/hints/linux.500
    sed \
      -E 's/^(GDBPATH|GREPPATH)/#\1/' \
      -i sys/unix/sysconf
    sed \
      -e 's,^HACKDIR=.*$,HACKDIR=\$(PREFIX)/games/lib/\$(GAME)dir,' \
      -e 's,^SHELLDIR=.*$,SHELLDIR=\$(PREFIX)/games,' \
      -e 's,^CFLAGS+=-DCRASHREPORT,#CFLAGS+=-DCRASHREPORT,' \
      -e 's,^NHCFLAGS+=-DGREPPATH,#NHCFLAGS+=-DGREPPATH,' \
      -e 's,/usr/bin/true,${coreutils}/bin/true,g' \
      -e 's,^endif   # QTDIR,endif   # QTDIR \
            QTDIR=${qt5.qtbase.dev},' \
      -e 's,PKG_CONFIG_PATH=$(QTDIR)/lib/pkgconfig,,' \
      -e 's,NHCFLAGS+=-DCOMPRESS[^ ]*,NHCFLAGS+=-DCOMPRESS=\\"${gzip}/bin/gzip\\" \\\
        -DCOMPRESS_EXTENSION=\\".gz\\",' \
      -i sys/unix/hints/macOS.500
    sed -e '/define CHDIR/d' \
        -e '/define ENHANCED_SYMBOLS/d' \
        -i include/config.h
  '';

  configurePhase = ''
    pushd sys/unix
    sh setup.sh hints/${hint}
    popd
  '';

  preBuild =
    let
      lua548 = fetchurl {
        url = "https://www.lua.org/ftp/lua-5.4.8.tar.gz";
        hash = "sha256-TxjdrhVOeT5G7qtyfFnvHAwMK3ROe5QhlxDXb1MGKa4=";
      };
    in
    ''
      mkdir -p lib
      tar zxf ${lua548} -C lib
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
    #! ${stdenv.shell} -e
    PATH=${binPath}:\$PATH

    if [ ! -d ${userDir} ]; then
      mkdir -p ${userDir}
      cp -r $out/games/lib/nethackuserdir/* ${userDir}
      chmod -R +w ${userDir}
    fi

    RUNDIR=\$(mktemp -d)

    cleanup() {
      rm -rf \$RUNDIR
    }
    trap cleanup EXIT

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
    install -Dm 555 util/makedefs -t $out/libexec/nethack/
    ${lib.optionalString (!(x11Mode || qtMode)) "install -Dm 555 util/dlb -t $out/libexec/nethack/"}
  '';

  desktopItems = lib.optionals (x11Mode || qtMode) [
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
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ olduser101 ];
    mainProgram = "nethack";
  };
})
