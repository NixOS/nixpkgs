{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  gitMinimal,
  makeWrapper,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "action-validator";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "mpalmer";
    repo = "action-validator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E0kqEzqw902Wg7QQNzOrtHQO9riSmAvDNcWIP3XmLSY=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-F8bJclpDpOdVET/dSIUYyP4DFcnhJDR2CV8poZtykko=";

  passthru.updateScript = nix-update-script { };

  postPatch = ''
    substituteInPlace Cargo.toml --replace-fail 'version = "0.0.0-git"' 'version = "${finalAttrs.version}"'
  '';

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = [ gitMinimal ];

  # The tests require a functional git installation and leaveDotGit appears broken https://github.com/NixOS/nixpkgs/issues/8567
  preCheck = ''
    git init -b main
    git add --all # action-validator tests ignore unstaged files
  '';

  postCheck = ''
    rm -rf .git
  '';

  postInstall = ''
    wrapProgram "$out/bin/action-validator" \
      --prefix PATH : ${lib.makeBinPath [ gitMinimal ]}
  '';

  meta = {
    description = "Tool to validate GitHub Action and Workflow YAML files";
    homepage = "https://github.com/mpalmer/action-validator";
    license = lib.licenses.gpl3Plus;
    mainProgram = "action-validator";
    maintainers = with lib.maintainers; [ thiagokokada ];
  };
})
