{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "lsh";
  version = "1.6.1";
  src = fetchFromGitHub {
    owner = "latitudesh";
    repo = "lsh";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Pyl8DSXMV13GYJn2kwCyr2Ds7+PaGiTnTyvdAxtCg2Y=";
  };
  vendorHash = "sha256-WAgD6vZ9xK+vvpchbcNq5Eqe4po1YJJ8jIAf2Q9HhCY=";
  subPackages = [ "." ];
  meta = {
    changelog = "https://github.com/latitudesh/lsh/releases/tag/v${finalAttrs.version}";
    description = "Command-Line Interface for Latitude.sh";
    homepage = "https://github.com/latitudesh/lsh";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dzmitry-lahoda ];
  };
})
