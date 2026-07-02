{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  gitMinimal,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aube";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "endevco";
    repo = "aube";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uwOEou6DH+bePNupYKmTc82xQV9T08bDmSPG9RU9yBk=";
  };

  cargoHash = "sha256-CBI44O2iMwdMym+ZOO9MvJQ73n+12J6FjzIXAOQTGT0=";

  nativeBuildInputs = [ cmake ]; # libz-ng-sys

  nativeCheckInputs = [ gitMinimal ];

  postInstall = ''
    rm -f $out/bin/generate-settings-docs
  '';

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  __structuredAttrs = true;

  meta = {
    description = "Fast Node.js package manager";
    homepage = "https://github.com/endevco/aube";
    changelog = "https://github.com/endevco/aube/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chillcicada ];
    mainProgram = "aube";
  };
})
