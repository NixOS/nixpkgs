{ stdenv, fetchurl }:
stdenv.mkDerivation {
  name = "conkeror-0.9.2";
  src = fetchurl {
    url = http://repo.or.cz/w/conkeror.git/snapshot/efacc207b0d6c7b3899fc584c9f48547b18da076.tar.gz;
    sha256 = "179rkf32p83dzgfjghc4kglb03h8aivddliynsydr6zxy8c4p28f";
  };
  installPhase = ''
    cp -r . $out
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
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
