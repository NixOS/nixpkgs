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
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "endevco";
    repo = "aube";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GiWg0f1LMGH0yEr97w2+p6CpC9zv4ZmP19gMsBlc+8w=";
  };

  cargoHash = "sha256-0L8bPxICB816zjZ6k98gg9isHocbb2oSAtDi8o7rG3U=";

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
