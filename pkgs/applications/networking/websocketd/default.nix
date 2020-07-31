{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "websocketd";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "joewalnes";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qc4yi4kwy7bfi3fb17w58ff0i95yi6m4syldh8j79930syr5y8q";
  };

  vendorSha256 = "05k31z4h3b327mh940zh52im4xfk7kf5phb8b7xp4l9bgckhz4lb";

  meta = with lib; {
    description = "Turn any program that uses STDIN/STDOUT into a WebSocket server";
    homepage = "http://websocketd.com/";
    maintainers = [ maintainers.bjornfor ];
    license = licenses.bsd2;
  };
}
