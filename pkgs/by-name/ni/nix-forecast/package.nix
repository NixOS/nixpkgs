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
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "getchoo";
    repo = "nix-forecast";
    tag = "v${version}";
    hash = "sha256-GTINiV+oHmu1/DmQsE7UjfAFFtH26LK35TveW437lPA=";
  };

  cargoHash = "sha256-FQph9QOc0JrVjdilUxjRc77/obICK7fgzcDuqAoE2cs=";

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  # TODO: Re-enable next update
  # doInstallCheck = true;
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
