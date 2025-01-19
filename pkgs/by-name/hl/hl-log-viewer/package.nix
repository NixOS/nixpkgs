{
  lib,
  rustPlatform,
  installShellFiles,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "hl-log-viewer";
  version = "0.30.2";

  src = fetchFromGitHub {
    owner = "pamburus";
    repo = "hl";
    rev = "v${version}";
    hash = "sha256-wYL3CFBj2k6YDSvWlcUdEnV20WIieCbvAW/PCTMXqPU=";
  };

  cargoHash = "sha256-LHK9T8hmwHvFqizsGoMjTMJI+n2QVog+JkM/A8D59Bw=";
  useFetchCargoVendor = true;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd hl \
      --bash <($out/bin/hl --shell-completions bash) \
      --fish <($out/bin/hl --shell-completions fish) \
      --zsh <($out/bin/hl --shell-completions zsh)
    $out/bin/hl --man-page >hl.1
    installManPage hl.1
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/hl --help
    $out/bin/hl --version | grep -e "hl ${version}"
    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "JSON and logfmt log converter to human readable representation";
    homepage = "https://github.com/pamburus/hl";
    changelog = "https://github.com/pamburus/hl/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "hl";
    maintainers = with maintainers; [ petrzjunior ];
  };
}
