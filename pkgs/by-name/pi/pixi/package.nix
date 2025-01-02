{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  installShellFiles,
  testers,
  pixi,
}:

rustPlatform.buildRustPackage rec {
  pname = "pixi";
  version = "0.38.0";

  src = fetchFromGitHub {
    owner = "prefix-dev";
    repo = "pixi";
    rev = "v${version}";
    hash = "sha256-F15GDw6zolaa4IheKyJ9kdmdiLazUiDUhnUM8gH/hgk=";
  };

  postPatch = ''
    # There are multiple `version-ranges` entries which is not supported by buildRustPackage.
    cp -f ${./Cargo.lock} Cargo.lock
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "async_zip-0.0.17" = "sha256-3k9rc4yHWhqsCUJ17K55F8aQoCKdVamrWAn6IDWo3Ss=";
      "pubgrub-0.2.1" = "sha256-8TrOQ6fYJrYgFNuqiqnGztnHOqFIEDi2MFZEBA+oks4=";
      "reqwest-middleware-0.3.3" = "sha256-KjyXB65a7SAfwmxokH2PQFFcJc6io0xuIBQ/yZELJzM=";
      "tl-0.7.8" = "sha256-F06zVeSZA4adT6AzLzz1i9uxpI1b8P1h+05fFfjm3GQ=";
      "uv-auth-0.0.1" = "sha256-xy/fgy3+YvSdfq5ngPVbAmRpYyJH27Cft5QxBwFQumU=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    libgit2
    openssl
  ];

  env = {
    LIBGIT2_NO_VENDOR = 1;
    OPENSSL_NO_VENDOR = 1;
  };

  # As the version is updated, the number of failed tests continues to grow.
  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd pixi \
      --bash <($out/bin/pixi completion --shell bash) \
      --fish <($out/bin/pixi completion --shell fish) \
      --zsh <($out/bin/pixi completion --shell zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = pixi;
  };

  meta = {
    description = "Package management made easy";
    homepage = "https://pixi.sh/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      aaronjheng
      edmundmiller
    ];
    mainProgram = "pixi";
  };
}
