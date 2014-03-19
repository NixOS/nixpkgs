{ stdenv, makeWrapper, writeText, vim, vimrc }:

let

  vimrcfile = writeText "vimrc" vimrc;

  p = builtins.parseDrvName vim.name;

in stdenv.mkDerivation rec {
  name = "${p.name}-with-vimrc-${p.version}";

  buildInputs = [ makeWrapper vim vimrcfile ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out
    cp -r ${vim}/* $out/

    chmod u+w $out/bin
    chmod u+w $out/share/vim

    ln -s ${vimrcfile} $out/share/vim/vimrc
    wrapProgram $out/bin/vim --set VIM "$out/share/vim"
  '';

  meta = with stdenv.lib; {
    description = "The most popular clone of the VI editor";
    homepage    = http://www.vim.org;
    platforms   = platforms.unix;
  };
}
