{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "opkssh";
  version = "0.19.2";

  src = fetchFromGitHub {
    owner = "openpubkey";
    repo = "opkssh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jdeYEF7/S0zFYtRJ+k+5XkySTK8mBTgpYPqeG7+NrKw=";
  };

  ldflags = [ "-X main.Version=${finalAttrs.version}" ];

  vendorHash = "sha256-0rOQ+WFRd/G4H+KB3P02ZyEOwlS+9vr51oTkviC0L1U=";

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
