{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "gobgp";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-XbErKP/F7E/e03b1rNTfpnAqkqcu2TwPtj2rV65HCnI=";
  };

  vendorHash = "sha256-XZIcjBMNZbNDYmZLiH5s5kFoSi62n5JruqnsnlQFP4I=";

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  ldflags = [
    "-s"
    "-w"
    "-extldflags '-static'"
  ];

  subPackages = [ "cmd/gobgp" ];

  meta = {
    description = "CLI tool for GoBGP";
    homepage = "https://osrg.github.io/gobgp/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ higebu ];
    mainProgram = "gobgp";
  };
})
