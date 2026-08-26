{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "grpcui";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "fullstorydev";
    repo = "grpcui";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-qJ8X4l4Efww6fJ1Xr/MXn2Nr7O0zCmDTb0YAWGInVp4=";
  };

  vendorHash = "sha256-S6GeFwxyrlHzsXWz66jrNa+mtoACn7w2oY3M9XjPusk=";

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
