{
  lib,
  fetchFromGitHub,
  installShellFiles,
  makeBinaryWrapper,
  nix,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-forecast";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "getchoo";
    repo = "nix-forecast";
    tag = "v${version}";
    hash = "sha256-kNSH2QbryNAfZXILQzMk9MHDzX4420KyQJOKW0Xrl7c=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-M4gMvF7v1uxBPh8it0DWSSSgWeES/QXSApeCFW+0dlI=";

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  # NOTE: Yes, we specifically need Nix. Lix does not have the newer
  # `path-info --json` output used internally
  postInstall = ''
    wrapProgram $out/bin/nix-forecast --prefix PATH : ${lib.makeBinPath [ nix ]}

    installShellCompletion --cmd nix-forecast \
      --bash completions/nix-forecast.bash \
      --fish completions/nix-forecast.fish \
      --zsh completions/_nix-forecast
  '';

  env = {
    COMPLETION_DIR = "completions";
  };

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Check the forecast for today's Nix builds";
    homepage = "https://github.com/getchoo/nix-forecast";
    changelog = "https://github.com/getchoo/nix-forecast/releases/tag/v${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "nix-forecast";
  };
}
