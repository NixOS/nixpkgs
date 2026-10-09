{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cacert,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stakk";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "glennib";
    repo = "stakk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DG9OaavOpj69ZElCJ3JQcuvRgknPvbbHTGzFDi0xLzg=";
  };

  cargoHash = "sha256-STjpYoOVQDLHtgnwKAJ/xl+yqYNiYO5J/KRs1OBVkAg=";

  useNextest = true;
  # The forgejo transport tests build a reqwest client, which needs a CA bundle.
  nativeCheckInputs = [ cacert ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };
  __structuredAttrs = true;

  meta = {
    description = "Bridge Jujutsu (jj) bookmarks to GitHub stacked pull requests";
    homepage = "https://github.com/glennib/stakk";
    changelog = "https://github.com/glennib/stakk/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      voidlily
      Br1ght0ne
    ];
    mainProgram = "stakk";
  };
})
