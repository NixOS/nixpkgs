{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "llama";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = "llama";
    rev = "v${version}";
    sha256 = "sha256-32UyFy269rifw4Hjw18FO0F79sDNW8dgJ2MdGXSzLWo=";
  };

  vendorSha256 = "sha256-nngto104p/qJpWM1NlmEqcrJThXSeCfcoXCzV1CClYQ=";

  meta = with lib; {
    description = "Terminal file manager";
    homepage = "https://github.com/antonmedv/llama";
    license = licenses.mit;
    maintainers = with maintainers; [ portothree ];
  };
}
