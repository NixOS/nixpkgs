{
  lib,
  stdenv,
  fetchurl,
  callPackage,
  ncurses,
  bash,
  gawk,
  gettext,
  pkg-config,
  # default vimrc
  vimrc ? fetchurl {
    name = "default-vimrc";
    url = "https://raw.githubusercontent.com/archlinux/svntogit-packages/68f6d131750aa778807119e03eed70286a17b1cb/trunk/archlinux.vim";
    sha256 = "18ifhv5q9prd175q3vxbqf6qyvkk6bc7d2lhqdk0q78i68kv9y0c";
  },
  # apple frameworks
  Carbon,
  Cocoa,
}:

let
  common = callPackage ./common.nix { };
in
stdenv.mkDerivation {
  pname = "vim";

  inherit (common)
    version
    outputs
    src
    postPatch
    hardeningDisable
    enableParallelBuilding
    enableParallelInstalling
    postFixup
    meta
    ;

  nativeBuildInputs = [
    gettext
    pkg-config
  ];
  buildInputs =
    [
      ncurses
      bash
      gawk
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Carbon
      Cocoa
    ];

  strictDeps = true;

  configureFlags =
    [
      "--enable-multibyte"
      "--enable-nls"
    ]
    ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      "vim_cv_toupper_broken=no"
      "--with-tlib=ncurses"
      "vim_cv_terminfo=yes"
      "vim_cv_tgetent=zero" # it does on native anyway
      "vim_cv_timer_create=yes"
      "vim_cv_tty_group=tty"
      "vim_cv_tty_mode=0660"
      "vim_cv_getcwd_broken=no"
      "vim_cv_stat_ignores_slash=yes"
      "vim_cv_memmove_handles_overlap=yes"
    ];

  # which.sh is used to for vim's own shebang patching, so make it find
  # binaries for the host platform.
  preConfigure = ''
    export HOST_PATH
    substituteInPlace src/which.sh --replace '$PATH' '$HOST_PATH'
  '';

  postInstall = ''
    ln -s $out/bin/vim $out/bin/vi
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

  __impureHostDeps = [ "/dev/ptmx" ];
}
