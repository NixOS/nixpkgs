{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "capslock";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "google";
    repo = "capslock";
    rev = "v${version}";
    hash = "sha256-8B9L/lLRxDI6/qUCbL8VM37glDFBTaqb0fGI9BYfICU=";
  };

  vendorHash = "sha256-gmvnpJurjhCGS3/FH6HBZ0Zwx57ArSaw5dLHtJXCFc8=";

  subPackages = [ "cmd/capslock" ];

  env.CGO_ENABLED = "0";

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
