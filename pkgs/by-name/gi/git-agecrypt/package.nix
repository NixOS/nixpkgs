{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libgit2,
  git,
  pkg-config,
  zlib,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-agecrypt";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "vlaci";
    repo = "git-agecrypt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tN5APSipMAS/vFQV9SsFlTGA8K4eF2U10kBVAzp1z/E=";
  };

  cargoHash = "sha256-xeucrpQb/fVN5XzPvr1VAR82/kAzj4DphdtqQUAzWpI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    zlib
  ];

  nativeCheckInputs = [ git ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Alternative to git-crypt using age instead of GPG";
    homepage = "https://github.com/vlaci/git-agecrypt";
    changelog = "https://github.com/vlaci/git-agecrypt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      kuznetsss
      vlaci
    ];
    mainProgram = "git-agecrypt";
  };
})
