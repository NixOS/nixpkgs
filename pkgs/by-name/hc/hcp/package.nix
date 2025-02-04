{
  lib,
  buildGoModule,
  fetchFromGitHub,
  getent,
  hcp,
  makeBinaryWrapper,
  nix-update-script,
  testers,
  xdg-utils,
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

  patches = [ ./remove-update-check.patch ];

  vendorHash = "sha256-/Nf180odZB5X3Fj4cfz0TdYEfGKtkkh4qI9eRfz+meQ=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  postInstall = ''
    wrapProgram $out/bin/hcp \
      --prefix PATH : ${
        lib.makeBinPath [
          getent
          # Uses xdg-open for links in `hcp auth login`, etc.
          xdg-utils
        ]
      }
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = hcp;
      command = "HOME=$TMPDIR hcp version";
      version = src.tag;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "HashiCorp Cloud Platform CLI";
    homepage = "https://github.com/hashicorp/hcp";
    changelog = "https://github.com/hashicorp/hcp/releases/tag/${src.tag}";
    mainProgram = "hcp";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      dbreyfogle
      getchoo
    ];
  };
}
