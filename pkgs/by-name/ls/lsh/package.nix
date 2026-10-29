{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "lsh";
  version = "1.5.8";
  src = fetchFromGitHub {
    owner = "latitudesh";
    repo = "lsh";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-BFhVCrl2LS5s38WBtkTjZ+IYCO9VQgIVmel3xwzaBI8=";
  };
  vendorHash = "sha256-vAZYd4fbXsZRqDvSQ1Y+lk3RVY06PqxdJF9DofTa6sQ=";
  subPackages = [ "." ];
  meta = {
    changelog = "https://github.com/latitudesh/lsh/releases/tag/v${finalAttrs.version}";
    description = "Command-Line Interface for Latitude.sh";
    homepage = "https://github.com/latitudesh/lsh";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dzmitry-lahoda ];
  };
})
