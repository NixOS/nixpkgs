{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "llama";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = "llama";
    rev = "v${version}";
    sha256 = "sha256-6Xuwl4IpzbVfJ2MhHeImPFWxL/Y6rhnBExlh64PeGdk=";
  };

  vendorSha256 = "sha256-zbfQtTDbVWFVGQyjqlkv3mTvEPkKImzXAIXcmkh4wqk=";

  meta = with lib; {
    description = "Terminal file manager";
    homepage = "https://github.com/antonmedv/llama";
    license = licenses.mit;
    maintainers = with maintainers; [ portothree ];
  };
}
