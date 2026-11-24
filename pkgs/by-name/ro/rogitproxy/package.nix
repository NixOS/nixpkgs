{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  openssh,
}:

buildGoModule {
  pname = "rogitproxy";
  version = "0-unstable-2026-11-21";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "rogitproxy";
    rev = "e16c8c66946a691a9577552719b397de2476b392";
    hash = "sha256-+IqojurYdwCSgDvvHI0n7AWXdvcC9/vqSVaGgQPohvo=";
  };

  vendorHash = "sha256-3jWwr4mnd5IkAYMQnpbKvRPt9cSWqXW9pZI8N32IM0c=";

  nativeCheckInputs = [
    gitMinimal
    openssh
  ];

  preCheck = ''
    export GIT_AUTHOR_NAME="Test"
    export GIT_AUTHOR_EMAIL="test@test"
    export GIT_COMMITTER_NAME="Test"
    export GIT_COMMITTER_EMAIL="test@test"
  '';

  meta = {
    description = "Read-only Git protocol proxy for a Tailscale tailnet";
    homepage = "https://github.com/tailscale/rogitproxy";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.squat ];
    mainProgram = "rogitproxy";
  };
}
