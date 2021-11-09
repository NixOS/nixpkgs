{ lib, stdenv, fetchFromGitHub, mlton }:

stdenv.mkDerivation {
  pname = "redprl";
  version = "unstable-2017-03-28";

  src = fetchFromGitHub {
    owner = "RedPRL";
    repo = "sml-redprl";
    rev = "bdf027de732e4a8d10f9f954389dfff0c822f18b";
    fetchSubmodules = true;
    sha256 = "0cihwnd78d3ksxp6mppifm7xpi3fsii5mixvicajy87ggw8z305c";
  };

  buildInputs = [ mlton ];

  postPatch = ''
    patchShebangs ./script/
  '';

  buildPhase = ''
    ./script/mlton.sh
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv ./bin/redprl $out/bin
  '';

  meta = with lib; {
    description = "A proof assistant for Nominal Computational Type Theory";
    homepage = "http://www.redprl.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ acowley ];
    platforms = platforms.unix;
  };
}
