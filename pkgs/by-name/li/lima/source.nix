{
  fetchFromGitHub,
}:

let
  version = "2.0.2";
in
{
  inherit version;

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = "lima";
    tag = "v${version}";
    hash = "sha256-MWNvHHyf2qZxt83D22tTKR6EXAeAgcoXE1YjXHc9SwQ=";
  };

  vendorHash = "sha256-fCqAf0buqA6GajP7SIsVPyKM3jY2n9CbS5hpa3dsWbc=";
}
