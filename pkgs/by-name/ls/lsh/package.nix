{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "lsh";
  version = "1.4.5";
  src = fetchFromGitHub {
    owner = "latitudesh";
    repo = "lsh";
    rev = "v${version}";
    sha256 = "sha256-UlpPJlL5tW+f3ZxrNk4D/pYEwDEeNY+mEnGykOyNKnA=";
  };
  vendorHash = "sha256-bQymPzEZqRvRi5RAvZZw6Gv9oqfdk1+UgbLoG5z1SQI=";
  subPackages = [ "." ];
  meta = {
    changelog = "https://github.com/latitudesh/lsh/releases/tag/v${version}";
    description = "Command-Line Interface for Latitude.sh";
    homepage = "https://github.com/latitudesh/lsh";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dzmitry-lahoda ];
  };
}
