{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "squix";
  version = "0.4.0-beta";

  src = fetchFromGitHub {
    owner = "eduardofuncao";
    repo = "squix";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lJOXzBgVgRdUi+btu/eOlYXDLhS2FLEnJQ/UjGk5jF4=";
  };

  vendorHash = "sha256-JRmNajvCb57dMo8eggOD1m4N01p2RSK8r49pmBB56Z0=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Minimal CLI tool for managing SQL queries across multiple databases";
    homepage = "https://github.com/eduardofuncao/squix";
    license = lib.licenses.mit;
    mainProgram = "squix";
    maintainers = with lib.maintainers; [ eduardofuncao ];
  };
})
