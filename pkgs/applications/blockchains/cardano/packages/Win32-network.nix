{ mkDerivation, base, fetchgit, lib }:
mkDerivation {
  pname = "Win32-network";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/Win32-network/";
    sha256 = "19wahfv726fa3mqajpqdqhnl9ica3xmf68i254q45iyjcpj1psqx";
    rev = "3825d3abf75f83f406c1f7161883c438dac7277d";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [ base ];
  description = "Win32 network API";
  license = lib.licenses.asl20;
}
