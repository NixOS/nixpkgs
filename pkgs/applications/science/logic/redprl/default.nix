{ stdenv, fetchgit, mlton }:
stdenv.mkDerivation {
  name = "redprl-2017-03-28";
  src = fetchgit {
    url = "https://github.com/RedPRL/sml-redprl.git";
    rev = "bdf027de732e4a8d10f9f954389dfff0c822f18b";
    sha256 = "0cihwnd78d3ksxp6mppifm7xpi3fsii5mixvicajy87ggw8z305c";
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
