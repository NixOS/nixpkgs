{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "capslock";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "google";
    repo = "capslock";
    rev = "v${version}";
    hash = "sha256-kRuEcrx9LBzCpXFWlc9bSsgZt84T8R8VFdbAWAseSPQ=";
  };

  vendorHash = "sha256-CUw4ukSAs12dprgcQRfdoKzY7gbzUCHk0t2SrUMtrxo=";

  subPackages = [ "cmd/capslock" ];

  env.CGO_ENABLED = "0";

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Capability analysis CLI for Go packages that informs users of which privileged operations a given package can access";
    homepage = "https://github.com/google/capslock";
    license = lib.licenses.bsd3;
    mainProgram = "capslock";
    maintainers = with lib.maintainers; [ katexochen ];
  };
}
