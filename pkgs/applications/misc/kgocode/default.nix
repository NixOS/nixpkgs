{ fetchgit, stdenv, cmake, kdelibs, automoc4 } :

stdenv.mkDerivation rec {
  name = "kgocode-0.0.1";

  buildInputs = [ cmake kdelibs automoc4 ];

  src = fetchgit {
    url = https://bitbucket.org/lucashnegri/kgocode.git;
    rev = "024536e4b2f371db4f51c1d80fb6b444352ff6a6";
    sha256 = "1cjxcy4w46rbx90jrikklh9vw7nz641gq7xlvrq3pjsszxn537gq";
  };

  meta = with stdenv.lib; {
    description = "Go code completion for Kate, KDevelop and others";
    longDescription = ''
      A plugin for KTextEditor (Kate, KDevelop, among others) that provides
      basic code completion for the Go programming language.
      Uses gocode as completion provider.
    '';
    homepage    = https://bitbucket.org/lucashnegri/kgocode/overview;
    maintainers = with maintainers; [ qknight ];
    license = licenses.gpl3Plus;
    platforms   = platforms.linux;
  };
}
