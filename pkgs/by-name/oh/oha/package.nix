{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  cacert,
  installShellFiles,
  libredirect,
  pkg-config,
  openssl,
  aws-lc,
  sqlite,
  zstd,
  rust-jemalloc-sys,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oha";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "hatoo";
    repo = "oha";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ujFZa/eo1rjmpgjsTxhKuXLWg4P0FYcRyOn1RJ03Ycw=";
  };

  cargoHash = "sha256-OTvWXJhk6bmiU5sIkAz5fz0nNgbsxafcPi30cunyEfU=";

  env = {
    CARGO_PROFILE_RELEASE_LTO = "fat";
    CARGO_PROFILE_RELEASE_CODEGEN_UNITS = "1";
  };

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    openssl
    aws-lc
    sqlite
    zstd
    rust-jemalloc-sys
  ];

  checkInputs = [ cacert ];
  nativeCheckInputs = [
    libredirect.hook
  ];

  preCheck = ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS="/etc/resolv.conf=$(realpath resolv.conf)"
  '';

  doCheck = true;
  checkFlags = [
    "--skip=test_google"
    "--skip=test_proxy"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash fish zsh; do
      installShellCompletion --cmd oha --$shell <($out/bin/oha --completions $shell)
    done
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "HTTP load generator inspired by rakyll/hey with tui animation";
    homepage = "https://github.com/hatoo/oha";
    changelog = "https://github.com/hatoo/oha/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jpds ];
    mainProgram = "oha";
  };
})
