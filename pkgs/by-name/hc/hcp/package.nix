{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  hcp,
}:

buildGoModule rec {
  pname = "hcp";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "hcp";
    tag = "v${version}";
    hash = "sha256-DyfrT4Z4pF7o6nBoacpEE0jT/dxRRm7nr3KsXJTwtOQ=";
  };

  vendorHash = "sha256-Tq7Lu9rZCLpy7CiZQey5/y1hZPEvdSsy1BgEFWNVeAk=";

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
