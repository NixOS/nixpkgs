{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mustache-go";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "cbroglie";
    repo = "mustache";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-PBU9p0CpqYCODOebkFuSCFx8eZhgBLgIt2t7CZ9js1k=";
  };

  vendorHash = "sha256-8IuIjowz7NoUUEIuEQ55uvvOT5PsaIJhaNIeZIIaXY4=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    homepage = "https://github.com/cbroglie/mustache";
    description = "Mustache template language in Go";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Zimmi48 ];
    mainProgram = "mustache";
  };
})
