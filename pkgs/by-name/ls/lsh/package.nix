{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "lsh";
  version = "1.5.7";
  src = fetchFromGitHub {
    owner = "latitudesh";
    repo = "lsh";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-OG1JjQ33BtsALG1CVO+N4N1Q7+6SW99U43lh1+cekDA=";
  };
  vendorHash = "sha256-SvbrrunOkJhIB5AlsCY7WrtE+Na/ExEJmVWqfjHNvx4=";
  subPackages = [ "." ];
  meta = {
    changelog = "https://github.com/latitudesh/lsh/releases/tag/v${finalAttrs.version}";
    description = "Command-Line Interface for Latitude.sh";
    homepage = "https://github.com/latitudesh/lsh";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dzmitry-lahoda ];
  };
})
