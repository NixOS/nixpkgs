{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  pkg-config,
  perl,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "release-plz";
  version = "0.3.113";

  src = fetchFromGitHub {
    owner = "MarcoIeni";
    repo = "release-plz";
    rev = "release-plz-v${version}";
    hash = "sha256-m33tBLNOU2+vjIICU0ggnNxLvD/fxJVSxT6bRih9e7U=";
  };

  cargoHash = "sha256-d7CltWp1RfQ8cJ6eLXF8spaWXBBEtla46FiRrzG5EVg=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    perl
  ];

  buildInputs = [ openssl ];

  buildAndTestSubdir = "crates/release_plz";

  # Tests depend on additional infrastructure to be running locally
  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${meta.mainProgram} \
      --bash <($out/bin/${meta.mainProgram} generate-completions bash) \
      --fish <($out/bin/${meta.mainProgram} generate-completions fish) \
      --zsh <($out/bin/${meta.mainProgram} generate-completions zsh)
  '';

  meta = {
    description = "Publish Rust crates from CI with a Release PR";
    homepage = "https://release-plz.ieni.dev";
    changelog = "https://github.com/MarcoIeni/release-plz/blob/release-plz-v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ dannixon ];
    mainProgram = "release-plz";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
