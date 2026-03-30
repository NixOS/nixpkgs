{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gh-token";
  version = "2.0.9";

  src = fetchFromGitHub {
    owner = "Link-";
    repo = "gh-token";
    rev = "v${version}";
    hash = "sha256-ff3Dzajh/7p0yNSKCHJzJcqkTpf09zuZ6Hp0ygDv6o0=";
  };

  vendorHash = "sha256-brAFqWdvaJwURdWb9m8x21nhuXeRxIJX6FsUfGiFIWQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Manage installation access tokens for GitHub apps from your terminal";
    homepage = "https://github.com/Link-/gh-token";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ norbertwnuk ];
    mainProgram = "gh-token";
  };
}
