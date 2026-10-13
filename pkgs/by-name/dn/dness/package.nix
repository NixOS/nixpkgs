{
  fetchFromGitHub,
  lib,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dness";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "nickbabcock";
    repo = "dness";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Znlygpq0EetCLjtZC39ksaVFeuwMmqI5FhHxsliw+oE=";
  };

  cargoHash = "sha256-2NT67tVMI511iISDln3p66Ls8XSLze0JSQZ50/s24tM=";

  doCheck = false; # Many tests require network access

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Dynamic DNS updating tool supporting a variety of providers";
    homepage = "https://github.com/nickbabcock/dness";
    maintainers = with lib.maintainers; [ logan-barnett ];
    mainProgram = "dness";
    license = lib.licenses.mit;
  };
})
