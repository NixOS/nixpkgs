{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  alsa-lib,
}:

let
  metaVersion = "0.1.13";
  # NOTE: git rev-parse --verify v${metaVersion}
  metaCommit = "1496a6f3c2bad88a5e4eb542b613015e0f480cdd";
  # NOTE: date -ud "@$(git log -1 --pretty=%ct ${metaCommit})" '+%Y-%m-%dT%H:%M:%SZ'
  metaCommitTimeRFC3339 = "2025-08-02T08:54:24Z";
in
buildGoModule {
  pname = "go-pray";
  version = metaVersion;

  src = fetchFromGitHub {
    owner = "0xzer0x";
    repo = "go-pray";
    rev = metaCommit;
    hash = "sha256-wi/sUjzNbVLbqwtM1BglmXgkaqMamjIsGS6EjlyeC9Y=";
  };

  vendorHash = "sha256-qMTg2Vsk0nte1O8sbNWN5CCCpgpWLvcb2RuGMoEngYE=";

  nativeBuildInputs = [
    pkg-config
    alsa-lib
    installShellFiles
  ];
  ldflags = [
    "-X github.com/0xzer0x/go-pray/internal/version.version=${metaVersion}"
    "-X github.com/0xzer0x/go-pray/internal/version.buildCommit=${metaCommit}"
    "-X github.com/0xzer0x/go-pray/internal/version.buildTime=${metaCommitTimeRFC3339}"
  ];

  buildInputs = [ alsa-lib ];

  postInstall = ''
    # NOTE: Create temporary config file to supress missing config error
    printf 'calculation: { method: "UAQ" }\nlocation: { lat: 0, long: 0 }\n' > tmpconfig.yml
    installShellCompletion --cmd go-pray \
      --bash <($out/bin/go-pray --config=tmpconfig.yml completion bash) \
      --fish <($out/bin/go-pray --config=tmpconfig.yml completion fish) \
      --zsh <($out/bin/go-pray --config=tmpconfig.yml completion zsh)
  '';

  meta = with lib; {
    description = "Prayer times CLI to remind you to Go pray";
    homepage = "https://github.com/0xzer0x/go-pray";
    changelog = "https://github.com/0xzer0x/go-pray/releases/tag/v${metaVersion}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ _0xzer0x ];
    platforms = platforms.linux;
    mainProgram = "go-pray";
  };
}
