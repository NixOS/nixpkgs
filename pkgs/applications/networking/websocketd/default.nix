{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "websocketd";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "joewalnes";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cp4iBSQ6Cd0+NPZ2i79Mulg1z17u//OCm3yoArbZEHs=";
  };

  vendorHash = "sha256-i5IPJ3srUXL7WWjBW9w803VSoyjwA5JgPWKsAckPYxY=";

  doCheck = false;

  meta = with lib; {
    description = "Turn any program that uses STDIN/STDOUT into a WebSocket server";
    homepage = "http://websocketd.com/";
    maintainers = [ maintainers.bjornfor ];
    license = licenses.bsd2;
  };
}
