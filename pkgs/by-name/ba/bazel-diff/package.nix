{
  lib,
  rustPlatform,
  fetchFromGitHub,
  buildPackages,
  gitMinimal,
  protobuf,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bazel-diff";
  version = "46.1.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Tinder";
    repo = "bazel-diff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eDjpBRkCRdITme3JIPeaPKq7tyzLaXkE01xy0WJLwYE=";
  };

  cargoHash = "sha256-81laUoduvxYHF9+w+kvS7AKv7/5xhm2ONOHuCOGLqJU=";

  postPatch = ''
    sed -i '0,/^version =/s/^version = .*/version = "${finalAttrs.version}"/' Cargo.toml
  '';

  cargoTestFlags = [
    "--lib"
    "--bin=bazel-diff"
  ];

  nativeBuildInputs = [
    protobuf
  ];

  nativeCheckInputs = [
    gitMinimal
  ];

  env.PROTOC = lib.getExe buildPackages.protobuf;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Determine impacted Bazel targets between two revisions";
    homepage = "https://github.com/Tinder/bazel-diff";
    changelog = "https://github.com/Tinder/bazel-diff/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      dreamingcodes
      water-sucks
    ];
    mainProgram = "bazel-diff";
  };
})
