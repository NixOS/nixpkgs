{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "capslock";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "google";
    repo = "capslock";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wkM7FTDO0PtMcijGF2umDF1nO2Clgo9hSaE+e2q7PDw=";
  };

  vendorHash = "sha256-cGQ8C8Fudto/IwYIZVcIUoVtN58M+RpD0K2Bd4cshZc=";

  subPackages = [ "cmd/capslock" ];

  env.CGO_ENABLED = "0";

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Capability analysis CLI for Go packages that informs users of which privileged operations a given package can access";
    homepage = "https://github.com/google/capslock";
    license = lib.licenses.bsd3;
    mainProgram = "capslock";
    maintainers = with lib.maintainers; [ sotormd ];
  };
})
