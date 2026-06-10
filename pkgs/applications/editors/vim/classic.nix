{
  fetchFromSourcehut,
  fetchurl,
  gawk,
  gettext,
  hostname,
  lib,
  libtool,
  ncurses,
  perl,
  pkg-config,
  stdenv,
  # default vimrc
  vimrc ? fetchurl {
    name = "default-vimrc";
    url = "https://raw.githubusercontent.com/archlinux/svntogit-packages/68f6d131750aa778807119e03eed70286a17b1cb/trunk/archlinux.vim";
    sha256 = "18ifhv5q9prd175q3vxbqf6qyvkk6bc7d2lhqdk0q78i68kv9y0c";
  },
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vim-classic";
  version = "8.3.0";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "vim-classic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BJuxs7pOMmPVew+W3d/6KFEah6I8TQoRJ4SK8/4daas=";
  };

  outputs = [
    "out"
    "xxd"
  ];

  patches = [
    ./classic.patch
  ];

  strictDeps = true;
  __structuredAttrs = true;

  enableParallelBuilding = true;

  nativeBuildInputs = [
    gettext
  ]
  ++ lib.optionals finalAttrs.doCheck [
    hostname
    libtool
    pkg-config
    perl
  ];
  buildInputs = [
    ncurses
  ];

  # Vim is not supporting _FORTIFY_SOURCE>=2: https://github.com/vim/vim/issues/5581.
  hardeningDisable = if stdenv.cc.isClang then [ "strictflexarrays1" ] else [ "fortify" ];

  configureFlags = [
    "--enable-multibyte"
    "--enable-nls"
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) (
    [
      "vim_cv_toupper_broken=no"
      "--with-tlib=ncurses"
      "vim_cv_terminfo=yes"
      "vim_cv_tgetent=zero" # it does on native anyway
      "vim_cv_tty_group=tty"
      "vim_cv_tty_mode=0660"
      "vim_cv_getcwd_broken=no"
      "vim_cv_stat_ignores_slash=yes"
      "vim_cv_memmove_handles_overlap=yes"
    ]
    ++ lib.optionals stdenv.hostPlatform.isFreeBSD [
      "vim_cv_timer_create=no"
      "vim_cv_timer_create_with_lrt=yes"
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isFreeBSD) [
      "vim_cv_timer_create=yes"
    ]
  );

  doCheck = false;
  checkPhase = ''
    make test
  '';

  # Use man from $PATH; escape sequences are still problematic.
  postPatch = ''
    substituteInPlace runtime/ftplugin/man.vim \
      --replace "/usr/bin/man " "man "
  '';

  postInstall = ''
    ln -s $out/bin/vim $out/bin/vi
    ln -s $out/bin/vim $out/bin/vim-classic
    mkdir -p $out/share/vim
    cp "${vimrc}" $out/share/vim/vimrc

    # Prevent bugs in the upstream makefile from silently failing and missing outputs.
    # Some of those are build-time requirements for other packages.
    for tool in ex xxd vi view vimdiff; do
      if [ ! -e "$out/bin/$tool" ]; then
        echo "ERROR: install phase did not install '$tool'."
        exit 1
      fi
    done
  '';

  # man page moving is done in postFixup instead of postInstall otherwise fixupPhase moves it right back where it was
  postFixup = ''
    moveToOutput bin/xxd "$xxd"
    moveToOutput share/man/man1/xxd.1.gz "$xxd"
    for manFile in $out/share/man/*/man1/xxd.1*; do
      # moveToOutput does not take full paths or wildcards...
      moveToOutput "share/man/$(basename "$(dirname "$(dirname "$manFile")")")/man1/xxd.1.gz" "$xxd"
    done
  '';

  meta = {
    description = "Vim Classic is a fork of Vim 8.2 for long-term maintenance";
    homepage = "https://vim-classic.org/";
    license = lib.licenses.vim;
    maintainers = with lib.maintainers; [
      corps-fini
    ];
    platforms = lib.platforms.unix;
    mainProgram = "vim";
    outputsToInstall = [
      "out"
      "xxd"
    ];
  };
})
