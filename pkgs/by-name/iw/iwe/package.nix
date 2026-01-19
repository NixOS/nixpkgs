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
  version = "0.0.59";

  src = fetchFromGitHub {
    owner = "iwe-org";
    repo = "iwe";
    tag = "iwe-v${finalAttrs.version}";
    hash = "sha256-6GaYFAN3Cz9VAvYaMQTAsXNolDuuVXfkrwqBqbr8Kfw=";
  };

  cargoHash = "sha256-1j1XAcwbct9wJrEWYpJFFzVRmjHliUmNxgprUF43/ew=";

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
