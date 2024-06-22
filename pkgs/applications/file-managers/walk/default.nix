{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "walk";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = "walk";
    rev = "v${version}";
    hash = "sha256-xs9K8WrckkpyzHnjYlzRsicMW+o7nTMYCIZVWOwx4PU=";
  };

  vendorHash = "sha256-p92H4JqklrV0c4vp9puAgDzBzMpwI40WPz9ix0e77l8=";

  meta = with lib; {
    description = "Terminal file manager";
    homepage = "https://github.com/antonmedv/walk";
    license = licenses.mit;
    maintainers = with maintainers; [ portothree surfaceflinger ];
    mainProgram = "walk";
  };
}
