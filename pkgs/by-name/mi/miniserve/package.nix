{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  openssl,
  cacert,
  stdenv,
  curl,
  versionCheckHook,
  nix-update-script,
  fetchpatch,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "miniserve";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "miniserve";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sSCS5jHhu0PBF/R3YqbR9krZghNNa2cPkLkK8kvWWd4=";
  };

  patches = [
    (fetchpatch {
      name = "upload.patch";
      url = "https://github.com/svenstaro/miniserve/commit/d41ade0d79e2c175515701350f763dd461c55964.patch";
      hash = "sha256-2xQPcJFjlvrCeobuDXm+eVZzDsKoQoZL7OXEJxncX5k=";
    })
  ];

  cargoHash = "sha256-Gb1k4sd2/OV1GskFZBn7EapZTlhb9LK19lJHVP7uCK0=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [ openssl ];

  nativeCheckInputs = [
    curl
    cacert
  ];

  checkFlags = [
    "--skip=bind_ipv4_ipv6::case_2"
    "--skip=qrcode_hidden_in_tty_when_disabled"
    "--skip=qrcode_shown_in_tty_when_enabled"
    "--skip=show_root_readme_contents"
    "--skip=validate_printed_urls"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/miniserve --print-manpage >miniserve.1
    installManPage miniserve.1

    installShellCompletion --cmd miniserve \
      --bash <($out/bin/miniserve --print-completions bash) \
      --fish <($out/bin/miniserve --print-completions fish) \
      --zsh <($out/bin/miniserve --print-completions zsh)
  '';

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool to serve files and directories over HTTP";
    homepage = "https://github.com/svenstaro/miniserve";
    changelog = "https://github.com/svenstaro/miniserve/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      figsoda
      defelo
    ];
    mainProgram = "miniserve";
  };
})
