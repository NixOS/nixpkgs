{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gomi";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "b4b4r07";
    repo = "gomi";
    tag = "v${version}";
    hash = "sha256-FZCvUG6lQH8CFivV/hbIgGQx4FCk1UtreiWXTQVi4+4=";
  };

  vendorHash = "sha256-8aw81DKBmgNsQzgtHCsUkok5e5+LeAC8BUijwKVT/0s=";

  subPackages = [ "." ];

  # https://github.com/babarot/gomi/blob/v1.6.0/.goreleaser.yaml#L20-L22
  ldflags = [
    "-X main.version=v${version}"
    # cd path/to/gomi; git switch -d "v${version}"; git show --format='%h' HEAD --quiet
    "-X main.revision=da44e9f"
    # cd path/to/gomi; git switch -d "v${version}"; date --date="@$(git show --format='%ct' HEAD --quiet)" --utc +'%Y-%m-%dT%H:%M:%SZ'
    "-X main.buildDate=2025-03-17T05:38:26Z"
  ];

  meta = {
    description = "Replacement for UNIX rm command";
    homepage = "https://github.com/b4b4r07/gomi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mimame
      ozkutuk
    ];
    mainProgram = "gomi";
  };
}
