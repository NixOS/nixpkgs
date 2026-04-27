{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  libxml2,
  openssl,
  curl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hurl";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "Orange-OpenSource";
    repo = "hurl";
    tag = finalAttrs.version;
    hash = "sha256-91E9UF8MzT2/Q1NzA7hkgTV4s6EExoBtlS8H+n9dZ6Y=";
  };

  cargoHash = "sha256-0gyvTHB4cSgKApGnSTiJgGk8TUCnkJQ/vlEQWsZi+98=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    libxml2
    openssl
    curl
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  # The actual tests require network access to a test server, but we can run an install check
  doCheck = false;
  doInstallCheck = true;

  postInstall = ''
    installManPage docs/manual/hurl.1 docs/manual/hurlfmt.1
    installShellCompletion --cmd hurl \
      --bash completions/hurl.bash \
      --zsh completions/_hurl \
      --fish completions/hurl.fish

    installShellCompletion --cmd hurlfmt \
      --zsh completions/_hurlfmt
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line tool that performs HTTP requests defined in a simple plain text format";
    homepage = "https://hurl.dev/";
    changelog = "https://github.com/Orange-OpenSource/hurl/blob/${finalAttrs.version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      eonpatapon
      defelo
    ];
    license = lib.licenses.asl20;
    mainProgram = "hurl";
  };
})
