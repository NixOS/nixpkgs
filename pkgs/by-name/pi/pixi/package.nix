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
  version = "0.24.2";

  src = fetchFromGitHub {
    owner = "prefix-dev";
    repo = "pixi";
    rev = "v${version}";
    hash = "sha256-Qlr4CcrCq29ig3FPFWCR5oOtFrbREm/7zyGXUB3XL98=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "async_zip-0.0.17" = "sha256-Q5fMDJrQtob54CTII3+SXHeozy5S5s3iLOzntevdGOs=";
      "cache-key-0.0.1" = "sha256-lJJqjxyAzGQKZi6RtzZ7A9pCAOyIJnstHoS8jlUWeGA=";
      "pubgrub-0.2.1" = "sha256-mAPyo2R996ymzCt6TAX2G7xU1C3vDGjYF0z7R8lI1yg=";
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
    "--skip=test_compressed_mapping_catch_missing_package"
    "--skip=test_compressed_mapping_catch_not_pandoc_not_a_python_package"
    "--skip=test_dont_record_not_present_package_as_purl"
    "--skip=test_incremental_lock_file"
    "--skip=test_purl_are_added_for_pypi"

    # `/usr/bin/env` is not available during build.
    # Error: /usr/bin/env: No such file or directory
    "--skip=test_clean_env"
    "--skip=test_full_env_activation"
    "--skip=test_task_with_env"
    "--skip=test_pixi_only_env_activation"
    "--skip=cli::shell_hook::tests::test_environment_json"
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
    maintainers = with maintainers; [ aaronjheng edmundmiller ];
    mainProgram = "pixi";
  };
}
