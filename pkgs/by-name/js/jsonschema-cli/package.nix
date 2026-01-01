{
  lib,
  fetchCrate,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jsonschema-cli";
<<<<<<< HEAD
  version = "0.38.1";
=======
  version = "0.37.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchCrate {
    pname = "jsonschema-cli";
    inherit (finalAttrs) version;
<<<<<<< HEAD
    hash = "sha256-W3pyT5DK8ADkWi7znuTDTq1hjRTOwhg9rSmuGZTX8r0=";
  };

  cargoHash = "sha256-C8A+cyNix0Q9OACyyPM3A74jZKNBCGz/622YsZqtY2E=";
=======
    hash = "sha256-d/l43flElIooDs/daz7kNVumY7WophO3RwnxMsUGXzc=";
  };

  cargoHash = "sha256-8fiAzUsYvWNjNhurvh6U2BXiQsBpTzsTo5DstK2MSB4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast command-line tool for JSON Schema validation";
    homepage = "https://github.com/Stranger6667/jsonschema";
    changelog = "https://github.com/Stranger6667/jsonschema/releases/tag/rust-v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "jsonschema-cli";
  };
})
