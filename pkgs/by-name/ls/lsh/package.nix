{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "lsh";
  version = "1.7.0";
  src = fetchFromGitHub {
    owner = "latitudesh";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-e+YIl5FjXsDDNUut1cUmQMsL9DPynT/t8rxy3AFpZy4=";
  };
  vendorHash = "sha256-btjvNJ8WuMPzriA1Z1xB64kAvOjoVuzksIbqSLD1ahg=";
  subPackages = [ "." ];
  meta = {
    changelog = "https://github.com/latitudesh/cli/releases/tag/v${finalAttrs.version}";
    description = "Command-Line Interface for Latitude.sh";
    homepage = "https://github.com/latitudesh/cli";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dzmitry-lahoda ];
  };
})
