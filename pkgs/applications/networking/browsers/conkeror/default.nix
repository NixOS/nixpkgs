{ stdenv, fetchgit, unzip, xulrunner, makeWrapper }:

stdenv.mkDerivation {
  name = "conkeror-1.0pre-20140616";

  src = fetchgit {
    url = git://repo.or.cz/conkeror.git;
    rev = "8a26fff5896a3360549e2adfbf06b1d57e909266";
    sha256 = "56f1c71ca1753a63d7599d3e8bf52277711b2693e7709ed7c146f34940441cb4";
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
