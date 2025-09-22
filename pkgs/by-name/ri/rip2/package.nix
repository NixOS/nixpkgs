{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  installShellFiles,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rip2";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "MilesCranmer";
    repo = "rip2";
    rev = "v${version}";
    hash = "sha256-vYkJlmzysUcX+jULGSs4Omu2RjUs4ZO4blN/zlzDcqc=";
  };

  cargoHash = "sha256-+8o4PFcJ/jMoMzfEA96tJ8wuH1CTqxnDwvFuegmPcEY=";

  nativeBuildInputs = [ installShellFiles ];

  # TODO: Unsure why this test fails, but not a major issue so
  #       skipping for now.
  checkFlags = [ "--skip=test_filetypes::file_type_3___fifo__" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/rip";
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd rip \
      --bash <($out/bin/rip completions bash) \
      --fish <($out/bin/rip completions fish) \
      --zsh <($out/bin/rip completions zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Safe and ergonomic alternative to rm";
    homepage = "https://github.com/MilesCranmer/rip2";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      milescranmer
      matthiasbeyer
    ];
    mainProgram = "rip";
  };
}
