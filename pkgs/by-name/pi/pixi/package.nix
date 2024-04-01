{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, openssl
, installShellFiles
, darwin
, testers
, pixi
}:

rustPlatform.buildRustPackage rec {
  pname = "pixi";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "prefix-dev";
    repo = "pixi";
    rev = "v${version}";
    hash = "sha256-wYk77i/33J+VJeT+Bi3L8DJv9quP7VJkcq3voA6U/1s=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "async_zip-0.0.16" = "sha256-M94ceTCtyQc1AtPXYrVGplShQhItqZZa/x5qLiL+gs0=";
      "cache-key-0.0.1" = "sha256-CvaYXtgd8eqzPNoXukjPwaoT/QOlUVKYNzD8Db6on9Q=";
      "pubgrub-0.2.1" = "sha256-1teDXUkXPbL7LZAYrlm2w5CEyb8g0bDqNhg5Jn0/puc=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    libgit2
    openssl
  ] ++ lib.optionals stdenv.isDarwin (
    with darwin.apple_sdk_11_0.frameworks; [ CoreFoundation IOKit SystemConfiguration Security ]
  );

  env = {
    LIBGIT2_NO_VENDOR = 1;
    OPENSSL_NO_VENDOR = 1;
  };

  # There are some CI failures with Rattler. Tests on Aarch64 has been skipped.
  # See https://github.com/prefix-dev/pixi/pull/241.
  doCheck = !stdenv.isAarch64;

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  checkFlags = [
    # Skip tests requiring network
    "--skip=add_channel"
    "--skip=add_functionality"
    "--skip=add_functionality_os"
    "--skip=add_functionality_union"
    "--skip=add_pypi_functionality"
    "--skip=test_alias"
    "--skip=test_cwd"
    "--skip=test_incremental_lock_file"
  ];

  postInstall = ''
    installShellCompletion --cmd pixi \
      --bash <($out/bin/pixi completion --shell bash) \
      --fish <($out/bin/pixi completion --shell fish) \
      --zsh <($out/bin/pixi completion --shell zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = pixi;
  };

  meta = with lib; {
    description = "Package management made easy";
    homepage = "https://pixi.sh/";
    license = licenses.bsd3;
    maintainers = with lib.maintainers; [ aaronjheng edmundmiller ];
    mainProgram = "pixi";
  };
}
