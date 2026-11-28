{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "lsh";
  version = "1.10.1";
  src = fetchFromGitHub {
    owner = "latitudesh";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-m3qOhWmhdgsrS/L7RnSiM4dHOKbd7V4iK/zb/JCx35o=";
  };
  vendorHash = "sha256-hAwtH+PDF4GouSjv9yHyElEU4nqdGKdCRmcHVDXLh9Y=";
  subPackages = [ "." ];
  meta = {
    changelog = "https://github.com/latitudesh/cli/releases/tag/v${finalAttrs.version}";
    description = "Command-Line Interface for Latitude.sh";
    homepage = "https://github.com/latitudesh/cli";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dzmitry-lahoda ];
  };
})
