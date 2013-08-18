{ stdenv, fetchgit, unzip, xulrunner, makeWrapper }:

stdenv.mkDerivation {
  name = "conkeror-1.0pre-20130817-1";

  src = fetchgit {
    url = git://repo.or.cz/conkeror.git;
    rev = "refs/tags/debian-1.0--pre+git130817-1";
    sha256 = "aef3c782ac98c031e7b99852f42538e225e151cd226cde3094823a5cae015fcf";
  };

  buildInputs = [ unzip makeWrapper ];

  installPhase = ''
    mkdir -p $out/libexec/conkeror
    cp -r * $out/libexec/conkeror

    makeWrapper ${xulrunner}/bin/xulrunner $out/bin/conkeror \
      --add-flags $out/libexec/conkeror/application.ini
  '';

  meta = {
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
    license = [ "MPLv1.1" "GPLv2" "LGPLv2.1" ];
    maintainers = with stdenv.lib.maintainers; [ astsmtl chaoflow ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
