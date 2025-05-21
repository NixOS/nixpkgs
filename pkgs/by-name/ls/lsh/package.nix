{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "lsh";
  version = "1.3.3";
  src = fetchFromGitHub {
    owner = "latitudesh";
    repo = "lsh";
    rev = "v${version}";
    sha256 = "0YpjG4u+wb4LRWzfTddKFwut0MBzEch+HZijmZiVXpE=";
  };
  vendorHash = "sha256-ogdyzfayleka4Y8x74ZtttD7MaeCl1qP/rQi9x0tMto=";
  subPackages = [ "." ];
  meta = with lib; {
    changelog = "https://github.com/latitudesh/lsh/releases/tag/v${version}";
    description = "Command-Line Interface for Latitude.sh";
    homepage = "https://github.com/latitudesh/lsh";
    license = licenses.mit;
    maintainers = [ lib.maintainers.dzmitry-lahoda ];
  };
}
