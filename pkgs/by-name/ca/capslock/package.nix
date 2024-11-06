{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "capslock";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "google";
    repo = "capslock";
    rev = "v${version}";
    hash = "sha256-w2dB8DUCjbuzdEfX4nmaGbf9TZH58t+NZtyMoBHVG8I=";
  };

  vendorHash = "sha256-ZRDoKB3/oxJhVFNWT71sKu8WbvIUyvXNKY1hD8ljo5U=";

  subPackages = [ "cmd/capslock" ];

  CGO_ENABLED = "0";

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Capability analysis CLI for Go packages that informs users of which privileged operations a given package can access";
    homepage = "https://github.com/google/capslock";
    license = lib.licenses.bsd3;
    mainProgram = "capslock";
    maintainers = with lib.maintainers; [ katexochen ];
  };
}
