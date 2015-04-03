{ stdenv, fetchgit, unzip, firefox, makeWrapper }:

stdenv.mkDerivation {
  name = "conkeror-1.0pre-20150319";

  src = fetchgit {
    url = git://repo.or.cz/conkeror.git;
    rev = "6450632b3f0c315f79e7a9856658083fe8fc9c29";
    sha256 = "18cqz1n2n6aimmgd69mdrgmkjf4207k7yz11wihka6b5z1hfiv64";
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
