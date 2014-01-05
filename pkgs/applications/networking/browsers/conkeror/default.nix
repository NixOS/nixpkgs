{ stdenv, fetchgit, unzip, xulrunner, makeWrapper }:

stdenv.mkDerivation {
  name = "conkeror-1.0pre-20131116-1";

  src = fetchgit {
    url = git://repo.or.cz/conkeror.git;
    rev = "refs/tags/debian-1.0--pre+git131116-1";
    sha256 = "6fe0f30487c5bb8f2183dc7c2e15cf29df7cc8b1950b5fc15c26510c74a1f7d3";
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
