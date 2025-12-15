{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "gotestdox";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "bitfield";
    repo = "gotestdox";
    rev = "v${version}";
    hash = "sha256-AZDXMwADOjcaMiofMWoHp+eSnD3a8iFtwpWDKl9Ess8=";
  };

  vendorHash = "sha256-kDSZ4RZTHDFmu7ernYRjg0PV7eBB2lH8q5wW3kTExDs=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for formatting Go test results as readable documentation";
    homepage = "https://github.com/bitfield/gotestdox";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
    mainProgram = "gotestdox";
  };
}
