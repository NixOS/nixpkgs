{ lib, stdenv, fetchzip }:

stdenv.mkDerivation {
  pname = "clprover";
  version = "1.0.3";

  src = fetchzip {
    url = "https://cgi.csc.liv.ac.uk/~ullrich/CLProver++/CLProver++-v1.0.3-18-04-2015.zip";
    sha256 = "10kmlg4m572qwfzi6hkyb0ypb643xw8sfb55xx7866lyh37w1q3s";
    stripRoot = false;
  };

  installPhase = ''
    mkdir $out
    cp -r bin $out/bin
    mkdir -p $out/share/clprover
    cp -r examples $out/share/clprover/examples
  '';

  meta = with lib; {
    description = "Resolution-based theorem prover for Coalition Logic implemented in C++";
    mainProgram = "CLProver++";
    homepage = "https://cgi.csc.liv.ac.uk/~ullrich/CLProver++/";
    license = licenses.gpl3; # Note that while the website states that it is GPLv2 but the file in the zip as well as the comments in the source state it is GPLv3
    maintainers = with maintainers; [ mgttlinger ];
    platforms = [ "x86_64-linux" ];
  };
}
