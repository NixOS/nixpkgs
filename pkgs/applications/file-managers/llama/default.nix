{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "llama";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = "llama";
    rev = "v${version}";
    sha256 = "sha256-pfNOA8YtxkRnFYZh91A54HhUAK/wZa0y/bLDwMCvu4U=";
  };

  vendorSha256 = "sha256-nngto104p/qJpWM1NlmEqcrJThXSeCfcoXCzV1CClYQ=";

  meta = with lib; {
    description = "Terminal file manager";
    homepage = "https://github.com/antonmedv/llama";
    license = licenses.mit;
    maintainers = with maintainers; [ portothree ];
  };
}
