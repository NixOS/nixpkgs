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
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "aube";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bQDDLgO5dG9kMF9VDnHGwuMZjWrbNT5Ia90rJrERDaE=";
  };

  cargoHash = "sha256-L9UiSO9UL8kBOebFXrZqbIJ/V4tobl1NYAdlktmX2lY=";

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
    homepage = "https://github.com/jdx/aube";
    changelog = "https://github.com/jdx/aube/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      chillcicada
      Br1ght0ne
    ];
    mainProgram = "aube";
  };
})
