{ stdenv, fetchgit, mlton }:
stdenv.mkDerivation {
  name = "redprl-2016-09-22";
  src = fetchgit {
    url = "https://github.com/RedPRL/sml-redprl.git";
    rev = "3215faf0d494f4ac14d6e10172329a161df192c4";
    sha256 = "0pcq4q9xy34j7ziwbly4qxccpkcrl92r9y11bv6hdkbzwm1g2a77";
    fetchSubmodules = true;
  };
  buildInputs = [ mlton ];
  patchPhase = ''
    patchShebangs ./script/
  '';
  buildPhase = ''
    ./script/mlton.sh
  '';
  installPhase = ''
    mkdir -p $out/bin
    mv ./bin/redprl $out/bin
  '';
  meta = {
    description = "A proof assistant for Nominal Computational Type Theory";
    homepage = "http://www.redprl.org/";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.acowley ];
    platforms = stdenv.lib.platforms.unix;
  };
}
