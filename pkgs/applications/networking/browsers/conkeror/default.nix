{ stdenv, fetchgit, unzip, xulrunner, makeWrapper }:

stdenv.mkDerivation {
  name = "conkeror-1.0pre-20140509";

  src = fetchgit {
    url = git://repo.or.cz/conkeror.git;
    rev = "eaf02dccf979d824667d177544103af000ae40bf";
    sha256 = "1896db59d260f34a459402cb0c252b636aab9bf0378ae663a6d039f15af5b350";
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
