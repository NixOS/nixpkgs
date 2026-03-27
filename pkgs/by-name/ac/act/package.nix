{
  lib,
  fetchFromGitHub,
  buildGoModule,
  testers,
  nix-update-script,
  act,
}:

let
  version = "0.2.86";
in
buildGoModule {
  pname = "act";
  inherit version;

  src = fetchFromGitHub {
    owner = "nektos";
    repo = "act";
    tag = "v${version}";
    hash = "sha256-nA7QzQYd4oa+OJiPLpfWNjavVJiCd0t62+qC2TpJcSM=";
  };

  vendorHash = "sha256-MsrWfrXuIi1m0vhDR05qbD4ynNpKvKwjUgDKbaq5iLs=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = act;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Run your GitHub Actions locally";
    mainProgram = "act";
    homepage = "https://github.com/nektos/act";
    changelog = "https://github.com/nektos/act/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kashw2
    ];
  };
}
