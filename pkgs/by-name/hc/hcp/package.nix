{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  hcp,
}:

buildGoModule rec {
  pname = "hcp";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "hcp";
    tag = "v${version}";
    hash = "sha256-YOOaQh1OsRn5EV9RmUdWWdHx5bMFC+a1qFzUGb6lpew=";
  };

  vendorHash = "sha256-/Nf180odZB5X3Fj4cfz0TdYEfGKtkkh4qI9eRfz+meQ=";

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
