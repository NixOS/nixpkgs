{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gost";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "go-gost";
    repo = "gost";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ep3ZjD+eVKl3PuooDuYeur8xDAcyy6ww2I7f3cYG03o=";
  };

  vendorHash = "sha256-lzyr6Q8yXsuer6dRUlwHEeBewjwGxDslueuvIiZUW70=";

  # Based on ldflags in upstream's .goreleaser.yaml
  ldflags = [
    "-s"
    "-X main.version=v${finalAttrs.version}"
  ];

  __darwinAllowLocalNetworking = true;

  # i/o timeout
  doCheck = !stdenv.hostPlatform.isDarwin;

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "-V";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple tunnel written in golang";
    homepage = "https://github.com/go-gost/gost";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pmy
      ramblurr
      moraxyc
    ];
    mainProgram = "gost";
  };
})
