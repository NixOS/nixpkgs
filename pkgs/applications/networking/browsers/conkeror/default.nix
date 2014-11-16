{ stdenv, fetchgit, unzip, firefox, makeWrapper }:

stdenv.mkDerivation {
  name = "conkeror-1.0pre-20140616";

  src = fetchgit {
    url = git://repo.or.cz/conkeror.git;
    rev = "98e89c7e5ff3a1069a0984338da01273cdb189a2";
    sha256 = "284ba966efebfa0aaa768abc1a4f901e2ecf5db9d0391d904a49118b0b94fcd7";
  };

  buildInputs = [ unzip makeWrapper ];

  installPhase = ''
    mkdir -p $out/libexec/conkeror
    cp -r * $out/libexec/conkeror

    makeWrapper ${firefox}/bin/firefox $out/bin/conkeror \
      --add-flags "-app $out/libexec/conkeror/application.ini"
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
