{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "mssqlhound";
  version = "2.0.4";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "SpecterOps";
    repo = "MSSQLHound";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iiOCpLmwmINwYl8FAlfedB8oE3vuDDGObR66qNuup/4=";
  };

  vendorHash = "sha256-Jro1aiZgdoG9ro9R8WRqSCjYb9UmIz6WIZ4/jAl9y+o=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Go collector for adding MSSQL attack paths to BloodHound with OpenGraph";
    homepage = "https://github.com/SpecterOps/MSSQLHound";
    changelog = "https://github.com/SpecterOps/MSSQLHound/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
    mainProgram = "mssqlhound";
  };
})
