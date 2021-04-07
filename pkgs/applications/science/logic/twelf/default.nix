{ lib, stdenv, fetchurl, pkg-config, smlnj, rsync }:

stdenv.mkDerivation rec {
  pname = "twelf";
  version = "1.7.1";

  src = fetchurl {
    url = "http://twelf.plparty.org/releases/twelf-src-${version}.tar.gz";
    sha256 = "0fi1kbs9hrdrm1x4k13angpjasxlyd1gc3ys8ah54i75qbcd9c4i";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ smlnj rsync ];

  buildPhase = ''
    export SMLNJ_HOME=${smlnj}
    make smlnj
  '';

  installPhase = ''
    mkdir -p $out/bin
    rsync -av bin/{*,.heap} $out/bin/
    bin/.mkexec ${smlnj}/bin/sml $out/ twelf-server twelf-server

    substituteInPlace emacs/twelf-init.el \
      --replace '(concat twelf-root "emacs")' '(concat twelf-root "share/emacs/site-lisp/twelf")'

    mkdir -p $out/share/emacs/site-lisp/twelf/
    rsync -av emacs/ $out/share/emacs/site-lisp/twelf/

    mkdir -p $out/share/twelf/examples
    rsync -av examples/ $out/share/twelf/examples/
    mkdir -p $out/share/twelf/vim
    rsync -av vim/ $out/share/twelf/vim/
  '';

  meta = {
    description = "Logic proof assistant";
    longDescription = ''
      Twelf is a language used to specify, implement, and prove properties of
      deductive systems such as programming languages and logics. Large
      research projects using Twelf include the TALT typed assembly language,
      a foundational proof-carrying-code system, and a type safety proof for
      Standard ML.
    '';
    homepage = "http://twelf.org/wiki/Main_Page";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jwiegley ];
    platforms = lib.platforms.unix;
  };
}
