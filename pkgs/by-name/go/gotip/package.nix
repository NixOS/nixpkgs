{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gotip";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "gotip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TV2q0euQijs2NlUV0WjWaf2qNGZB8PWwhlJxrMTPs3Y=";
  };

  vendorHash = "sha256-EDjIepX1fr3hk2ompvxXqqEZIa/Heol9nnvAMmfhif8=";

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Go test interactive picker";
    homepage = "https://github.com/lusingander/gotip";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "gotip";
  };
})
