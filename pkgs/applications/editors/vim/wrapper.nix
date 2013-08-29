{ stdenv, makeWrapper, writeText, vim, vimrc }:

let

  vimrcfile = writeText "vimrc" (if vimrc == null then "" else vimrc);

in stdenv.mkDerivation rec {
  name = "vimwrapper-${vim.version}";

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
