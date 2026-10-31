{
  lib,
  buildGoModule,
  go_1_25,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "stl";
  version = "0.1.0-alpha.79";

  vendorHash = "sha256-OWfYAhV9jFuRTMtjjMdut2htFcYzjDl/RqgzesOBptk=";

  src = fetchFromGitHub {
    owner = "stainless-api";
    repo = "stainless-api-cli";
    rev = "v${version}";
    hash = "sha256-PrN4/mJmPgDeMXI5W/pM37uCJUurpkMvYGzSlabXKho=";
  };

  nativeBuildInputs = [ go_1_25 ];

  doCheck = false;

  meta = {
    description = "The official CLI for the Stainless REST API";
    homepage = "https://github.com/stainless-api/stainless-api-cli";
    license = lib.licenses.asl20;
    mainProgram = "stl";
    maintainers = [ lib.maintainers.sd-st ];
    platforms = lib.platforms.all;
  };
}
