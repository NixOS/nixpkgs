{ stdenv, fetchgit, unzip, xulrunner, makeWrapper }:

stdenv.mkDerivation {
  name = "conkeror-1.0pre-20140212";

  src = fetchgit {
    url = git://repo.or.cz/conkeror.git;
    rev = "07064d76d10e0978c6de535e21f4597d44560fbd";
    sha256 = "b03a7debee8583ff7a3f2d95474f60e956f0e24dbd1a8fd22412de1d6627f322";
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
