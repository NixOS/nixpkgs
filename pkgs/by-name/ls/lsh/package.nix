{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "lsh";
  version = "1.5.3";
  src = fetchFromGitHub {
    owner = "latitudesh";
    repo = "lsh";
    rev = "v${version}";
    sha256 = "sha256-W+0yuBfDjHNMEaf+T0FSVMzRyZgkeXrFwsY47ksDD5U=";
  };
  vendorHash = "sha256-kOGHLrnpVQe8gy827CeP+1f2fy4WpUfWDfaNq/JmXpU=";
  subPackages = [ "." ];
  meta = {
    changelog = "https://github.com/latitudesh/lsh/releases/tag/v${version}";
    description = "Command-Line Interface for Latitude.sh";
    homepage = "https://github.com/latitudesh/lsh";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dzmitry-lahoda ];
  };
}
