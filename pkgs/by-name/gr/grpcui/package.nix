{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "grpcui";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "fullstorydev";
    repo = "grpcui";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-qamroFdchUtpZE5/6nanfLWXEUR/mXD+O89rdJL1wm4=";
  };

  vendorHash = "sha256-rj7Ha5zsulosy0CEqDSwax3bCf21PpOTELVzw1hXceo=";

  doCheck = false;

  subPackages = [ "cmd/grpcui" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "Interactive web UI for gRPC, along the lines of postman";
    homepage = "https://github.com/fullstorydev/grpcui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pradyuman ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "grpcui";
  };
})
