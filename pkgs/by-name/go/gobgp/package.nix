{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "gobgp";
  version = "4.11.0";

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-lqXEV0Ptk4OpJ6cRWqW2gZb6HSbL3Ue/M3+vcRqEGfg=";
  };

  vendorHash = "sha256-qQrA5uR6f/MAWSV8Sn9eibUCXanV304LqDLzfJRdPSQ=";

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
