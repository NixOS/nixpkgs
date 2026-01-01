{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule rec {
  pname = "regolith";
<<<<<<< HEAD
  version = "1.6.2";
=======
  version = "1.6.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Bedrock-OSS";
    repo = "regolith";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-J4DkEjN+hPK6fu9dIuHdY6gu1imb0sB/KdWnXYJSgw8=";
=======
    hash = "sha256-4STEivb2nlIYE6X0vnO8L4UtFrtmaNS+rxtuE0SwKmA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # Requires network access.
  doCheck = false;

<<<<<<< HEAD
  vendorHash = "sha256-jQeIPJJyANS+U9NrjLSnXHAecCK4rHPZrP5JFsMwcm8=";
=======
  vendorHash = "sha256-EWfc4VzVrg1D012dsPqdXoiGpBjpQRYiWNd0wrWlw34=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-X main.buildSource=nix"
    "-X main.version=${version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Add-on Compiler for the Bedrock Edition of Minecraft";
    homepage = "https://github.com/Bedrock-OSS/regolith";
    changelog = "https://github.com/Bedrock-OSS/regolith/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ arexon ];
    mainProgram = "regolith";
  };
}
