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
  version = "0.39.4";

  src = fetchFromGitHub {
    owner = "prefix-dev";
    repo = "pixi";
    tag = "v${version}";
    hash = "sha256-GOjJYRONOZqoJxv3Lqz8UthruAx5P+Dpg7LWT1eLBII=";
  };

  cargoPatches = [
    # There are multiple `version-ranges` entries which is not supported by buildRustPackage.
    ./Cargo.lock.patch
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-WbkSjpdjOztW/979yPBjh4BGbQbzOJUZAZcUeHoAJ4w=";

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
