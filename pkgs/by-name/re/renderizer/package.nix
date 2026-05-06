{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "renderizer";
  version = "2.0.13";

  src = fetchFromGitHub {
    owner = "gomatic";
    repo = "renderizer";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-jl98LuEsGN40L9IfybJhLnbzoYP/XpwFVQnjrlmDL9A=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commitHash=${finalAttrs.src.rev}"
    "-X main.date=19700101T000000"
  ];

  vendorHash = null;

  meta = {
    description = "CLI to render Go template text files";
    mainProgram = "renderizer";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.gpl3;
    maintainers = [ ];
  };
})
