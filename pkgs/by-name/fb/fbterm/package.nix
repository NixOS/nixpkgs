{
  stdenv,
  autoreconfHook,
  fetchFromGitLab,
  fetchpatch,
  fetchurl,
  fontconfig,
  freetype,
  gpm,
  lib,
  ncurses,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.7-2";
  pname = "fbterm";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "fbterm";
    rev = "debian/${finalAttrs.version}";
    hash = "sha256-vRUZgFpA1IkzkLzl7ImT+Yff5XqjFbUlkHmj/hd7XDE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    ncurses
  ];
  buildInputs = [
    gpm
    freetype
    fontconfig
    ncurses
  ];

  makeFlags = [
    "AR:=$(AR)"
  ];

  # preConfigure = ''
  #   sed -e '/ifdef SYS_signalfd/atypedef long long loff_t;' -i src/fbterm.cpp
  #   sed -e '/install-exec-hook:/,/^[^\t]/{d}; /.NOEXPORT/iinstall-exec-hook:\
  #   ' -i src/Makefile.in
  #   export HOME=$PWD;
  #   export NIX_LDFLAGS="$NIX_LDFLAGS -lfreetype"
  # '';

  preInstall = ''
    export HOME=$PWD
  '';

  postInstall = ''
    mkdir -p "$out/share/terminfo"
    tic -a -v2 -o"$out/share/terminfo" terminfo/fbterm

    mkdir -p "$out/etc/fbterm"
    # Vendored from https://aur.archlinux.org/cgit/aur.git/plain/fbtermrc?h=fbterm
    cp "${./fbtermrc}" "$out/etc/fbterm/fbtermrc"
  '';

  # Patches vendored from
  # https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=fbterm
  patches = [
    # https://aur.archlinux.org/cgit/aur.git/plain/fbconfig.patch?h=fbterm
    ./fbconfig.patch
    # https://aur.archlinux.org/cgit/aur.git/plain/color_palette.patch?h=fbterm
    ./color_palette.patch
    # https://aur.archlinux.org/cgit/aur.git/plain/fbterm.patch?h=fbterm
    ./fbterm.patch
    # https://aur.archlinux.org/cgit/aur.git/plain/0001-Fix-build-with-gcc-6.patch?h=fbterm
    ./0001-Fix-build-with-gcc-6.patch
    # https://aur.archlinux.org/cgit/aur.git/plain/fix_ftbfs_crosscompile.patch?h=fbterm
    ./fix_ftbfs_crosscompile.patch
    # https://aur.archlinux.org/cgit/aur.git/plain/fix_ftbfs_epoll.patch?h=fbterm
    ./fix_ftbfs_epoll.patch
  ];

  meta = {
    description = "Framebuffer terminal emulator";
    mainProgram = "fbterm";
    homepage = "https://salsa.debian.org/debian/fbterm";
    maintainers = with lib.maintainers; [
      lovesegfault
      raskin
    ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
