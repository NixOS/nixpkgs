{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cbom";
  version = "0.1.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "qelens";
    repo = "cbom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xwMuipbwgzhaORPQ9U0eVi+68Ml7J/SH+naWcjV5n2w=";
  };

  cargoHash = "sha256-+vvABoPyaeH6+CPITeT7OtsLfVfdZQfjF8DU1yE1Hmw=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CBOM Generator & PQC Readiness Scanner";
    homepage = "https://github.com/qelens/cbom";
    changelog = "https://github.com/qelens/cbom/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cbom";
  };
})
