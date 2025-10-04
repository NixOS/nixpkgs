{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyperfine";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "hyperfine";
    rev = "v${version}";
    hash = "sha256-c8yK9U8UWRWUSGGGrAds6zAqxAiBLWq/RcZ6pvYNpgk=";
  };

  cargoHash = "sha256-eZpGqkowp/R//RqLRk3AIbTpW3i9e+lOWpfdli7S4uE=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage doc/hyperfine.1

    installShellCompletion \
      $releaseDir/build/hyperfine-*/out/hyperfine.{bash,fish} \
      --zsh $releaseDir/build/hyperfine-*/out/_hyperfine
  '';

  meta = {
    description = "Command-line benchmarking tool";
    homepage = "https://github.com/sharkdp/hyperfine";
    changelog = "https://github.com/sharkdp/hyperfine/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      figsoda
      thoughtpolice
    ];
    mainProgram = "hyperfine";
  };
}
