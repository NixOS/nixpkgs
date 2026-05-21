{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gotest";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "rakyll";
    repo = "gotest";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-i9kM421O8sbL4SSQrEeRbtDaqOCA1y22b7QCxvt4Oow=";
  };

  vendorHash = "sha256-Zq8alVfojJbrzw3fpYnYDxAMc/rYO9WIuRb1OcNcBaw=";

  subPackages = [ "." ];

  meta = {
    description = "go test with colors";
    mainProgram = "gotest";
    homepage = "https://github.com/rakyll/gotest";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
