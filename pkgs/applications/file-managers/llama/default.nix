{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "llama";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = "llama";
    rev = "v${version}";
    sha256 = "sha256-mJUxi2gqTMcodznCUDb2iB6j/p7bMUhhBLtZMbvfE1c=";
  };

  vendorHash = "sha256-nngto104p/qJpWM1NlmEqcrJThXSeCfcoXCzV1CClYQ=";

  meta = with lib; {
    description = "Terminal file manager";
    homepage = "https://github.com/antonmedv/llama";
    license = licenses.mit;
    maintainers = with maintainers; [ portothree ];
  };
}
