{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  nixfmt,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "knixl";
  version = "1.11.3";

  src = fetchFromGitHub {
    owner = "1stvamp";
    repo = "knixl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RBMKQssJQ/+jPYKmTE+GcsCuSepBhEY1PaPJ2y6tpFs=";
  };

  cargoHash = "sha256-WFTcyG2uXp7WRkO4skP9DXBDUco1BUe0aAVl4FhSKJ0=";

  __structuredAttrs = true;

  nativeBuildInputs = [ makeWrapper ];

  # always prefer nixfmt in project prefix, as nixfmt is pinned in the lockfile as knixl formats
  # what it generates and different versions of nixfmt would create drift and version skew.
  postInstall = ''
    wrapProgram $out/bin/knixl --suffix PATH : ${lib.makeBinPath [ nixfmt ]}
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate maintainable, human-readable Nix from small amounts of opinionated KDL";
    homepage = "https://knixl.dev";
    changelog = "https://github.com/1stvamp/knixl/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ _1stvamp ];
    mainProgram = "knixl";
  };
})
