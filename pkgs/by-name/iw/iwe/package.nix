{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "iwe";
<<<<<<< HEAD
  version = "0.0.57";
=======
  version = "0.0.56";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "iwe-org";
    repo = "iwe";
    tag = "iwe-v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-BtNeTMDttAbozFHIe/hlOkEfIFPUFSDvWsJWY9+hKfk=";
  };

  cargoHash = "sha256-TvWoleEhjsV73Qfi/yTeje1CawhdETB/dFPlah6aDwY=";
=======
    hash = "sha256-nEn2iR2/ROboalMAXJV4y8qZiN36QkaWin+sMLZSKMQ=";
  };

  cargoHash = "sha256-fi16wLc/ZQV2bJHiIo7HVP+IS8zuoJeQQ7kV0cJ9GZ8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  cargoBuildFlags = [
    "--package=iwe"
    "--package=iwes"
  ];

  postPatch = ''
    substituteInPlace crates/iwe/tests/common/mod.rs --replace-fail \
      'binary_path.push("target");' \
      'binary_path.push("target/${stdenv.hostPlatform.rust.rustcTarget}");'
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^iwe-v(.*)$"
    ];
  };

  meta = {
    description = "Personal knowledge management system (editor plugin & command line utility)";
    homepage = "https://iwe.md/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      phrmendes
      HeitorAugustoLN
    ];
    mainProgram = "iwe";
  };
})
