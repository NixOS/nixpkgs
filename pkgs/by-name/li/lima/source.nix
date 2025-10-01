{
  fetchFromGitHub,
}:

let
  version = "1.2.1";
in
{
  inherit version;

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = "lima";
    tag = "v${version}";
    hash = "sha256-90fFsS5jidaovE2iqXfe4T2SgZJz6ScOwPPYxCsCk/k=";
  };

  vendorHash = "sha256-8S5tAL7GY7dxNdyC+WOrOZ+GfTKTSX84sG8WcSec2Os=";
}
