{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gh-token";
  version = "2.0.8";

  src = fetchFromGitHub {
    owner = "Link-";
    repo = "gh-token";
    rev = "v${version}";
    hash = "sha256-aoi5w2iryz8bbzt6ZQ9t7nR0Kh7mXdYbZBjpyoivEYw=";
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
