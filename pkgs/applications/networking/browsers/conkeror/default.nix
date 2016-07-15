{ stdenv, fetchgit, unzip, firefox, makeWrapper }:

stdenv.mkDerivation rec {
  pkgname = "conkeror";
  version = "1.0.3";
  name = "${pkgname}-${version}";
 
  src = fetchgit {
    url = git://repo.or.cz/conkeror.git;
    rev = "refs/tags/${version}";
    sha256 = "06fhfk8km3gd1lc19543zn0c71zfbn8wsalinvm1dbgi724f52pd";
  };

  buildInputs = [ unzip makeWrapper ];

  installPhase = ''
    mkdir -p $out/libexec/conkeror
    cp -r * $out/libexec/conkeror

    makeWrapper ${firefox}/bin/firefox $out/bin/conkeror \
      --add-flags "-app $out/libexec/conkeror/application.ini"
  '';

  meta = with stdenv.lib; {
    description = "A keyboard-oriented, customizable, extensible web browser";
    longDescription = ''
      Conkeror is a keyboard-oriented, highly-customizable, highly-extensible
      web browser based on Mozilla XULRunner, written mainly in JavaScript,
      and inspired by exceptional software such as Emacs and vi. Conkeror
      features a sophisticated keyboard system, allowing users to run commands
      and interact with content in powerful and novel ways. It is
      self-documenting, featuring a powerful interactive help system.
    '';
    homepage = http://conkeror.org/;
    license = with licenses; [ mpl11 gpl2 lgpl21 ];
    maintainers = with maintainers; [ astsmtl chaoflow ];
    platforms = platforms.linux;
  };
}
