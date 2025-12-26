{
  fetchFromGitHub,
}:

let
  version = "1.2.2";
in
{
  inherit version;

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = "lima";
    tag = "v${version}";
    hash = "sha256-bIYF/bsOMuWTkjD6fe6by220/WQGL+VWEBXmUzyXU98=";
  };

  vendorHash = "sha256-8S5tAL7GY7dxNdyC+WOrOZ+GfTKTSX84sG8WcSec2Os=";
}
