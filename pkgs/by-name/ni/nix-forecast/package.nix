{
  lib,
  fetchFromGitHub,
  installShellFiles,
  makeBinaryWrapper,
  nix,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-forecast";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "getchoo";
    repo = "nix-forecast";
    rev = "refs/tags/v${version}";
    hash = "sha256-jfS7DXEIVHihC0/kH9W8ZJDOjoWuxdRvLMfzknElvrg=";
  };

  cargoHash = "sha256-EHqHdcMI1K7DqhmFfr0ipfAsyM7cP9/22bMs4uIV2To=";

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

  meta = {
    description = "Check the forecast for today's Nix builds";
    homepage = "https://github.com/getchoo/nix-forecast";
    changelog = "https://github.com/getchoo/nix-forecast/releases/tag/${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "nix-forecast";
  };
}
