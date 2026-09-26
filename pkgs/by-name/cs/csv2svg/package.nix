{
  lib,
  rustPlatform,
  fetchCrate,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "csv2svg";
  version = "0.2.3";

  src = fetchCrate {
    pname = "csv2svg";
    inherit (finalAttrs) version;
    hash = "sha256-DNnMYpzQTzGVsAp0YScqiO260mwShVTE/cwXkU/Q5IE=";
  };

  cargoHash = "sha256-f6ZMCkMVkPi4XfzRUZq7JDhCBz57K58UqY69T9mNzrU=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Take a csv as input and outputs svg";
    homepage = "https://github.com/Canop/csv2svg";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.progrm_jarvis ];
    mainProgram = "csv2svg";
  };
})
