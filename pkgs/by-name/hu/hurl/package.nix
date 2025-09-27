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
}:

rustPlatform.buildRustPackage rec {
  pname = "hurl";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "Orange-OpenSource";
    repo = "hurl";
    tag = version;
    hash = "sha256-dmPXI2RHEi/wcdVVwBRtBgNXyBXFnm44236pqYjxgBs=";
  };

  cargoHash = "sha256-1bZaSdMJe39cDEOoqW82zS5NvOlZDGe1ia56BjXddyc=";

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

  meta = {
    description = "Command line tool that performs HTTP requests defined in a simple plain text format";
    homepage = "https://hurl.dev/";
    changelog = "https://github.com/Orange-OpenSource/hurl/blob/${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      eonpatapon
      figsoda
    ];
    license = lib.licenses.asl20;
    mainProgram = "hurl";
  };
}
