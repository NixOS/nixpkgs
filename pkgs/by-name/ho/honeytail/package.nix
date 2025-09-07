{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "honeytail";
  version = "1.6.0";
  vendorHash = "sha256-LtiiLGLjhbfT49A6Fw5CbSbnmTHMxtcUssr+ayCVrvY=";

  src = fetchFromGitHub {
    owner = "honeycombio";
    repo = "honeytail";
    rev = "v${version}";
    hash = "sha256-S0hIgNNzF1eNe+XJs+PT7EUIl5oJCXu+B/zQago4sf8=";
  };

  meta = with lib; {
    description = "Agent for ingesting log file data into honeycomb.io and making it available for exploration";
    homepage = "https://honeycomb.io/";
    license = licenses.asl20;
    maintainers = [ maintainers.iand675 ];
  };
}
