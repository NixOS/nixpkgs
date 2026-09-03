{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "noya-cli";
  version = "0.0.31";

  src = fetchFromGitHub {
    owner = "sebastienrousseau";
    repo = "noya-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VYknRxZrrrXcL7FBiDHtZDvZc9HwLzOL8jQNaBnKHnY=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage docs/noyafmt.1 docs/noyavalidate.1
    installShellCompletion --bash --name noyafmt complete/noyafmt.bash
    installShellCompletion --bash --name noyavalidate complete/noyavalidate.bash
    installShellCompletion --zsh complete/_noyafmt complete/_noyavalidate
    installShellCompletion --fish complete/noyafmt.fish complete/noyavalidate.fish
  '';

  meta = {
    description = "YAML formatter (noyafmt) and JSON Schema validator (noyavalidate) built on the noyalib library";
    homepage = "https://github.com/sebastienrousseau/noya-cli";
    changelog = "https://github.com/sebastienrousseau/noya-cli/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = [ ];
    mainProgram = "noyafmt";
  };
})
