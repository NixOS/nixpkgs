{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "sesh";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "joshmedeski";
    repo = "sesh";
    rev = "v${version}";
    hash = "sha256-nihyctFnDRLiDgHeXfn/q4G5IVEAOxh9MqFcsInK9UI=";
  };

  vendorHash = "sha256-zt1/gE4bVj+3yr9n0kT2FMYMEmiooy3k1lQ77rN6sTk=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Smart session manager for the terminal";
    homepage = "https://github.com/joshmedeski/sesh";
    changelog = "https://github.com/joshmedeski/sesh/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gwg313 ];
    mainProgram = "sesh";
  };
}
