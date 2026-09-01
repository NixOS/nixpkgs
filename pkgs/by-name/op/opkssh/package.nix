{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "opkssh";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "openpubkey";
    repo = "opkssh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c+ZcC9m+PfwFyLSz+dwahYdQe+wKHQHECT+gNp1rdQU=";
  };

  ldflags = [ "-X main.Version=${finalAttrs.version}" ];

  vendorHash = "sha256-BmU/8Y6CweVnOeHftQhacKKLccQk1uNljzHe+/zkUn4=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/openpubkey/opkssh";
    description = "Enables SSH to be used with OpenID Connect";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      johnrichardrinehart
      sarcasticadmin
    ];
    mainProgram = "opkssh";
  };
})
