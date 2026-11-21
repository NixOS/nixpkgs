{
  lib,
  stdenv,
  nix-update-script,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
}:
buildNpmPackage (finalAttrs: {
  pname = "nadesiko3";
  version = "3.8.9";

  src = fetchFromGitHub {
    owner = "kujirahand";
    repo = "nadesiko3";
    tag = finalAttrs.version;
    hash = "sha256-K6LjsOPWEBKD0LEj7Sa5e+9kDJJeexbcwqtwv/yDQSw=";
  };

  npmDepsHash = "sha256-a0BrvWz5/q412ALlvlhxq/AJA+u7DLemt+s8ef0WOVw=";

  strictDeps = true;
  __structuredAttrs = true;

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace package.json \
      --replace-fail \
      "\"build:command\": \"cross-env REPORT_ERR=1 npm run check:command && cross-env REPORT_ERR=1 node src/cnako3.mjs batch/build_command.nako3 && node batch/generate_command_list.mjs\"," \
      "\"build:command\": \"npm run check:command && node src/cnako3.mjs batch/build_command.nako3 && node batch/generate_command_list.mjs\","
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Japanese Programming Language Nadesiko v3 (JavaScript/TypeScript)";
    homepage = "https://nadesi.com/";
    changelog = "https://github.com/kujirahand/nadesiko3/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kangazero
    ];
    mainProgram = "cnako3";
  };
})
