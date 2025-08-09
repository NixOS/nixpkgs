{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch2,
  pkg-config,
  installShellFiles,
  libxml2,
  openssl,
  curl,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "hurl";
  version = "6.1.1";

  src = fetchFromGitHub {
    owner = "Orange-OpenSource";
    repo = "hurl";
    tag = version;
    hash = "sha256-NtvBw8Nb2eZN0rjVL/LPyIdY5hBJGnz/cDun6VvwYZE=";
  };

  cargoHash = "sha256-WyNActmsHpr5fgN1a3X9ApEACWFVJMVoi4fBvKhGgZ0=";

  patches = [
    # Fix build with libxml-2.14, remove after next hurl release
    # https://github.com/Orange-OpenSource/hurl/pull/3977
    (fetchpatch2 {
      name = "fix-libxml_2_14";
      url = "https://github.com/Orange-OpenSource/hurl/commit/7c7b410c3017aeab0dfc74a6144e4cb8e186a10a.patch?full_index=1";
      hash = "sha256-XjnCRIMwzfgUMIhm6pQ90pzA+c2U0EuhyvLUZDsI2GI=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    installShellFiles
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
