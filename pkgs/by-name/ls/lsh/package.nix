{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "lsh";
  version = "1.6.3";
  src = fetchFromGitHub {
    owner = "latitudesh";
    repo = "lsh";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-A0uZLcwFIuimSgwItDSfDCcDLZqI+q6C5iPyJgyUelQ=";
  };
  vendorHash = "sha256-MlpNAEbdl8AHu0uKhW/p0NTBROdGHKN+ODrcRCs9t4s=";
  subPackages = [ "." ];
  meta = {
    changelog = "https://github.com/latitudesh/lsh/releases/tag/v${finalAttrs.version}";
    description = "Command-Line Interface for Latitude.sh";
    homepage = "https://github.com/latitudesh/lsh";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dzmitry-lahoda ];
  };
})
