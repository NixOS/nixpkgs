{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "nix-auth";
  version = "0.1.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "nix-auth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-epsg+elWnZoPjFV/hc113j+JGuxL/ggcEmJJv+Niajo=";
  };

  vendorHash = "sha256-5X+GG5h9rZTLhDvL6m9LrU5WGT5Ev+aXZ+5ffksBIM8=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/numtide/nix-auth/internal/version.Version=${finalAttrs.version}"
  ];

  __darwinAllowLocalNetworking = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nix access-token management tool";
    homepage = "https://github.com/numtide/nix-auth";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    mainProgram = "nix-auth";
  };
})
