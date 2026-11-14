{
  mkDerivation,
  fetchFromGitHub,
  base,
  bytestring,
  network,
  lib,
}:
mkDerivation {
  pname = "client-ip-echo";
  version = "0.1.0.5";
  src = fetchFromGitHub {
    owner = "jerith666";
    repo = "client-ip-echo";
    rev = "e81db98d04c13966b2ec114e01f82487962055a7";
    hash = "sha256-yhuWFyKjIDJ4pywD0ikxU7PJ79GgvVj6LxC3Gur6Pws=";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base
    bytestring
    network
  ];
  description = "Accepts TCP connections and echoes the client's IP address back to it";
  license = lib.licenses.lgpl3;
  mainProgram = "client-ip-echo";
}
