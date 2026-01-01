{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "emmylua_ls";
<<<<<<< HEAD
  version = "0.18.0";
=======
  version = "0.17.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "EmmyLuaLs";
    repo = "emmylua-analyzer-rust";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-JXe+I0CViJAXOnWzilYpjWquYFzZGIP5y6HS6KosYPU=";
=======
    hash = "sha256-CAYSaRjpQwnPZojeX/VyV9/xz8SY8Lt+e1wc79qvGZg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  buildAndTestSubdir = "crates/emmylua_ls";

<<<<<<< HEAD
  cargoHash = "sha256-UVuXeGmSvAwHs/U0s/mByiZCwa2refz1l8eJvcCoagk=";
=======
  cargoHash = "sha256-nGSN7LqvAwYg2Z+2tTAc+vIwrYmb+W0OLw9EeG7e/V8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/emmylua_ls";
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "EmmyLua Language Server";
    homepage = "https://github.com/EmmyLuaLs/emmylua-analyzer-rust";
    changelog = "https://github.com/EmmyLuaLs/emmylua-analyzer-rust/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mrcjkb
    ];
    platforms = lib.platforms.all;
    mainProgram = "emmylua_ls";
  };
})
