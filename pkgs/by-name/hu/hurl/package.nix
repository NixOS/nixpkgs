{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  installShellFiles,
  libxml2,
  openssl,
  stdenv,
  curl,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "hurl";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "Orange-OpenSource";
    repo = "hurl";
    rev = "refs/tags/${version}";
    hash = "sha256-+GmIKxD5wHovhKXuV2IbDX43gbD8OxJzWvH3Z0MwwV4=";
  };

  cargoHash = "sha256-exAEJhHm7zTzXykkLyz46C0GJ7/7HYEwdfCd8zUDZ/A=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs =
    [
      libxml2
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
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

  meta = with lib; {
    description = "Command line tool that performs HTTP requests defined in a simple plain text format";
    homepage = "https://hurl.dev/";
    changelog = "https://github.com/Orange-OpenSource/hurl/blob/${version}/CHANGELOG.md";
    maintainers = with maintainers; [
      eonpatapon
      figsoda
    ];
    license = licenses.asl20;
    mainProgram = "hurl";
  };
}
