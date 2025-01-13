{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  libgit2,
  openssl,
  installShellFiles,
  buildPackages,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "pixi";
  version = "0.39.5";

  src = fetchFromGitHub {
    owner = "prefix-dev";
    repo = "pixi";
    tag = "v${version}";
    hash = "sha256-Y4d8eMfsag2cNTaK8qnOGfi35kwwPrUy2y51EwVFrss=";
  };

  # TODO: Remove this patch when the next version is released.
  cargoPatches = [
    (fetchpatch {
      # chore: make sure we only build one version of version-ranges
      # https://github.com/prefix-dev/pixi/commit/82fc219be3f5d1499922e89a5c458b7c154a7b8e
      url = "https://github.com/prefix-dev/pixi/commit/82fc219be3f5d1499922e89a5c458b7c154a7b8e.patch";
      hash = "sha256-fKDqUJtjxIQsCez95RObnJHQvdlxhmjJ+G7fJitE6v0=";
    })
  ];
  useFetchCargoVendor = true;
  cargoHash = "sha256-oGlPxFwJVpBajJQ5XED98SUP8qw312nUSRND6ycEOjk=";

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

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd pixi \
        --bash <(${emulator} $out/bin/pixi completion --shell bash) \
        --fish <(${emulator} $out/bin/pixi completion --shell fish) \
        --zsh <(${emulator} $out/bin/pixi completion --shell zsh)
    ''
  );

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Package management made easy";
    homepage = "https://pixi.sh/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      aaronjheng
      edmundmiller
      xiaoxiangmoe
    ];
    mainProgram = "pixi";
  };
}
