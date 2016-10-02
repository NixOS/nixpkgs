{ stdenv, fetchgit
, ncurses }:

stdenv.mkDerivation rec {

  name = "tecoc-git-${version}";
  version = "20150606";

  src = fetchgit {
    url = "https://github.com/blakemcbride/TECOC.git";
    rev = "d7dffdeb1dfb812e579d6d3b518545b23e1b50cb";
    sha256 = "11zfa73dlx71c0hmjz5n3wqcvk6082rpb4sss877nfiayisc0njj";
  };

  buildInputs = [ ncurses ];

  configurePhase = ''
    cp src/makefile.linux src/Makefile    
  '';
  buildPhase = ''
    make CC=${stdenv.cc}/bin/cc -C src/
  '';
  installPhase = ''
    mkdir -p $out/bin $out/share/doc/${name} $out/lib/teco/macros
    cp src/tecoc $out/bin
    cp src/aaout.txt doc/* $out/share/doc/${name}
    cp lib/* lib2/* $out/lib/teco/macros
    (cd $out/bin
     ln -s tecoc Make
     ln -s tecoc mung
     ln -s tecoc teco
     ln -s tecoc Inspect )
  '';
	
  meta = with stdenv.lib; {
    description = "A clone of the good old TECO editor";
    longDescription = ''
      For those who don't know: TECO is the acronym of Tape Editor and
      COrrector (because it was a paper tape edition tool in its debut 
      days). Now the acronym follows after Text Editor and Corrector, 
      or Text Editor Character-Oriented.
      
      TECO is a character-oriented text editor, originally developed
      bu Dan Murphy at MIT circa 1962. It is also a Turing-complete
      imperative interpreted programming language for text
      manipulation, done via user-loaded sets of macros. In fact, Emacs
      was born as a set of Editor MACroS for TECO.

      TECOC is a portable C implementation of TECO-11.
 '';
    homepage = https://github.com/blakemcbride/TECOC;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
# TODO: test in other platforms - especially Darwin
