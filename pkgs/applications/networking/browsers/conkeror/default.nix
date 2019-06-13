{ stdenv, fetchgit, unzip, firefox-esr, makeWrapper }:

stdenv.mkDerivation rec {
  pkgname = "conkeror";
  version = "1.0.4";
  name = "${pkgname}-${version}";
 
  src = fetchgit {
    url = git://repo.or.cz/conkeror.git;
    rev = "refs/tags/${version}";
    sha256 = "10c57wqybp9kcjpkb01wxq0h3vafcdb1g5kb4k8sb2zajg59afv8";
  };

  buildInputs = [ unzip makeWrapper ];

  installPhase = ''
    mkdir -p $out/libexec/conkeror
    cp -r * $out/libexec/conkeror

    makeWrapper ${firefox-esr}/bin/firefox $out/bin/conkeror \
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
    maintainers = with maintainers; [ astsmtl ];
    platforms = platforms.linux;
  };
}
