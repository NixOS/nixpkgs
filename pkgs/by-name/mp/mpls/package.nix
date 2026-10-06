{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "mpls";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "mhersson";
    repo = "mpls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3rXBQ1gvN2gesoFoQf0n/bnNG3/b94Y/jeTZDiXL+h4=";
  };

  vendorHash = "sha256-NGcl9KgdUPwWotAhRNlULF+RQXgQ2mdFctZLfGTiRkQ=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mhersson/mpls/cmd.Version=${finalAttrs.version}"
    "-X github.com/mhersson/mpls/internal/mpls.Version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Live preview of markdown using Language Server Protocol";
    homepage = "https://github.com/mhersson/mpls";
    changelog = "https://github.com/mhersson/mpls/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jervw ];
    mainProgram = "mpls";
  };
})
