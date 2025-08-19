{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nasm,
}:

rustPlatform.buildRustPackage rec {
  pname = "sic-image-cli";
  version = "0.22.4";

  src = fetchFromGitHub {
    owner = "foresterre";
    repo = "sic";
    rev = "v${version}";
    hash = "sha256-PFbHHO3m4mnV5s8DVev/iao9sC3FYht0whTHYzO25Yo=";
  };

  cargoHash = "sha256-HL/KCC8Y42OFL1LXoewmH1Bxp6FICuDjkTnK5DE94Ms=";

  nativeBuildInputs = [
    installShellFiles
    nasm
  ];

  postBuild = ''
    cargo run --example gen_completions
  '';

  postInstall = ''
    installShellCompletion sic.{bash,fish}
    installShellCompletion --zsh _sic
  '';

  meta = {
    description = "Accessible image processing and conversion from the terminal";
    homepage = "https://github.com/foresterre/sic";
    changelog = "https://github.com/foresterre/sic/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "sic";
  };
}
