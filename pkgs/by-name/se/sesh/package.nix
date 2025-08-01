{
  lib,
  fetchFromGitHub,
  buildGoModule,
  go-mockery,
}:
buildGoModule rec {
  pname = "sesh";
  version = "2.17.1";

  nativeBuildInputs = [
    go-mockery
  ];
  src = fetchFromGitHub {
    owner = "joshmedeski";
    repo = "sesh";
    rev = "v${version}";
    hash = "sha256-olt61AR/Tq8lLh65V0/+GDrWjCi9hrkNbHR9LOX7kY0=";
  };

  preBuild = ''
    mockery
  '';
  vendorHash = "sha256-TLl8HZnsVvtx6jqusTETP0l3zTmzYmuV4NJIM958VcQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Smart session manager for the terminal";
    homepage = "https://github.com/joshmedeski/sesh";
    changelog = "https://github.com/joshmedeski/sesh/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gwg313
      randomdude
    ];
    mainProgram = "sesh";
  };
}
