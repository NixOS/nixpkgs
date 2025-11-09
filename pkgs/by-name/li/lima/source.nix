{
  fetchFromGitHub,
}:

let
  version = "2.0.1";
in
{
  inherit version;

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = "lima";
    tag = "v${version}";
    hash = "sha256-GPrx4pvD6AxYIvAS+Mz8gFZ/Z7HeFFoHh3LOtAJ9bhI=";
  };

  vendorHash = "sha256-dA6zdrhN73Y8InlrCEdHgYwe5xbUlvKx0IMis2nWgWE=";
}
