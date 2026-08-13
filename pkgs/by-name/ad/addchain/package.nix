{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "addchain";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "mmcloughlin";
    repo = "addchain";
    tag = "v${version}";
    fetchSubmodules = false;
    hash = "sha256-msuZgNYqN1QldrbXJJ4BFXYhUsllAPt8W0KRrr8p6TM=";
  };

  vendorHash = "sha256-qxlVGkbm95WFmH0+48XRXwrF7HRUWFxYHFzmFOaj4GA=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mmcloughlin/addchain/meta.buildversion=${version}"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  subPackages = [ "cmd/addchain" ];

  __structuredAttrs = true;

  meta = {
    description = "addchain generates short addition chains for exponents of cryptographic interest with results rivaling the best hand-optimized chains";
    homepage = "https://github.com/mmcloughlin/addchain";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      ambiso
    ];
    mainProgram = "addchain";
  };
}
