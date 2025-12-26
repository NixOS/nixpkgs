{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  hcp,
}:

buildGoModule rec {
  pname = "hcp";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "hcp";
    tag = "v${version}";
    hash = "sha256-D9foh9WxnglW2Jw7Dg3aZhnQgHj0UpB4pPy87UAan/Y=";
  };

  vendorHash = "sha256-oRutfFkFgjF19WEfwjNDbBu5mhFGh1tsgKeTsP5rA3M=";

  preCheck = ''
    export HOME=$TMPDIR
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "HashiCorp Cloud Platform CLI";
    homepage = "https://github.com/hashicorp/hcp";
    changelog = "https://github.com/hashicorp/hcp/releases/tag/v${version}";
    mainProgram = "hcp";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      dbreyfogle
    ];
  };
}
