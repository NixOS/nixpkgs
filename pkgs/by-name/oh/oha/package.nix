{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  cacert,
  libredirect,
  pkg-config,
  openssl,
  rust-jemalloc-sys,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oha";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "hatoo";
    repo = "oha";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fjWfv/RuEqU0krVfHNxByzHdREVL7dD/tSEw7X1gaGk=";
  };

  cargoHash = "sha256-v+OfQEfAwHxX+FfC0UK2F8/e2tJKaI3zQpg+3hk2hV4=";

  env = {
    CARGO_PROFILE_RELEASE_LTO = "fat";
    CARGO_PROFILE_RELEASE_CODEGEN_UNITS = "1";
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    openssl
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
