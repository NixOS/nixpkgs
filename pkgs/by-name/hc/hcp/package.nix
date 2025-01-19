{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitUpdater,
  hcp,
}:

buildGoModule rec {
  pname = "hcp";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-YOOaQh1OsRn5EV9RmUdWWdHx5bMFC+a1qFzUGb6lpew=";
  };

  vendorHash = "sha256-/Nf180odZB5X3Fj4cfz0TdYEfGKtkkh4qI9eRfz+meQ=";

  preCheck = ''
    export HOME=$TMPDIR
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "HCP Command-Line Interface";
    homepage = "https://github.com/hashicorp/hcp";
    changelog = "https://github.com/hashicorp/hcp/raw/v${version}/CHANGELOG.md";
    mainProgram = "hcp";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      dbreyfogle
    ];
  };
}
