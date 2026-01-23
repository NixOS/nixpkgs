{
  fetchFromGitHub,
}:

let
  version = "2.0.3";
in
{
  inherit version;

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = "lima";
    tag = "v${version}";
    hash = "sha256-NoHNmJ6z7eZTzjl8ps3wFY2e68FcoBsu5ZhE0NXt95g=";
  };

  vendorHash = "sha256-SeLYVQI+ZIbR9qVaNyF89VUvXdfv1M5iM+Cbas6e2E0=";
}
