{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mustache-go";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "cbroglie";
    repo = "mustache";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-1Kx3CnNxyRyRixMd49HfVAPQhyxU0qMw/H1mD0ugOdk=";
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
