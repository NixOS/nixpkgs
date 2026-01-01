{
  fetchFromGitHub,
  lib,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "emmylua_doc_cli";
<<<<<<< HEAD
  version = "0.19.0";
=======
  version = "0.17.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "EmmyLuaLs";
    repo = "emmylua-analyzer-rust";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-bdvJInMuWJq7MZa+4wrKBn0myLTHCayhDAhB8Stjp6A=";
=======
    hash = "sha256-CAYSaRjpQwnPZojeX/VyV9/xz8SY8Lt+e1wc79qvGZg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  buildAndTestSubdir = "crates/emmylua_doc_cli";

<<<<<<< HEAD
  cargoHash = "sha256-bF6bdTbcHDecj+wVoNsaKBzsz96d3vo6cqp5MjSbT4E=";
=======
  cargoHash = "sha256-nGSN7LqvAwYg2Z+2tTAc+vIwrYmb+W0OLw9EeG7e/V8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/emmylua_doc_cli";
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  meta = {
    description = "Professional documentation generator creating beautiful, searchable API docs from your Lua code and annotations.";
    homepage = "https://github.com/EmmyLuaLs/emmylua-analyzer-rust";
    changelog = "https://github.com/EmmyLuaLs/emmylua-analyzer-rust/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mrcjkb
    ];
    platforms = lib.platforms.all;
    mainProgram = "emmylua_doc_cli";
  };
})
