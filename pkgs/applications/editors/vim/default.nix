{ lib, stdenv, fetchurl, fetchpatch, callPackage, ncurses, gettext, pkg-config
# default vimrc
, vimrc ? fetchurl {
    name = "default-vimrc";
    url = "https://raw.githubusercontent.com/archlinux/svntogit-packages/68f6d131750aa778807119e03eed70286a17b1cb/trunk/archlinux.vim";
    sha256 = "18ifhv5q9prd175q3vxbqf6qyvkk6bc7d2lhqdk0q78i68kv9y0c";
  }
# apple frameworks
, Carbon, Cocoa
}:

let
  common = callPackage ./common.nix {};
in
stdenv.mkDerivation {
  pname = "vim";

  inherit (common) version src postPatch hardeningDisable enableParallelBuilding meta;

  nativeBuildInputs = [ gettext pkg-config ];
  buildInputs = [ ncurses ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ Carbon Cocoa ];

  patches = [
    (fetchpatch {
      url = "https://github.com/vim/vim/commit/b7081e135a16091c93f6f5f7525a5c58fb7ca9f9.patch";
      name = "CVE-2021-3770.patch";
      sha256 = "0xk5q1lsq99hinrwnfdi01i0zzr9s9f0bfq8244bb0nvwadlq302";
    })
    (fetchpatch {
      url = "https://github.com/vim/vim/commit/65b605665997fad54ef39a93199e305af2fe4d7f.patch";
      name = "CVE-2021-3778.patch";
      sha256 = "1s4nbaz2nfl96zdnh8xwf6vsrby7xf6pjbfkc4c5y3h0mf2llb2h";
    })
    (fetchpatch {
      url = "https://github.com/vim/vim/commit/35a9a00afcb20897d462a766793ff45534810dc3.patch";
      name = "CVE-2021-3796.patch";
      sha256 = "0d538dkgkdfp3z501bifgm4c8amlqdp3mjqjmhdd9cadza4amix9";
    })
  ];

  configureFlags = [
    "--enable-multibyte"
    "--enable-nls"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "vim_cv_toupper_broken=no"
    "--with-tlib=ncurses"
    "vim_cv_terminfo=yes"
    "vim_cv_tgetent=zero" # it does on native anyway
    "vim_cv_tty_group=tty"
    "vim_cv_tty_mode=0660"
    "vim_cv_getcwd_broken=no"
    "vim_cv_stat_ignores_slash=yes"
    "ac_cv_sizeof_int=4"
    "vim_cv_memmove_handles_overlap=yes"
    "vim_cv_memmove_handles_overlap=yes"
  ];

  postInstall = ''
    ln -s $out/bin/vim $out/bin/vi
    mkdir -p $out/share/vim
    cp "${vimrc}" $out/share/vim/vimrc
  '';

  __impureHostDeps = [ "/dev/ptmx" ];

  # To fix the trouble in vim73, that it cannot cross-build with this patch
  # to bypass a configure script check that cannot be done cross-building.
  # http://groups.google.com/group/vim_dev/browse_thread/thread/66c02efd1523554b?pli=1
  # patchPhase = ''
  #   sed -i -e 's/as_fn_error.*int32.*/:/' src/auto/configure
  # '';
}
