{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  openssl,
  rustPlatform,
  darwin,
  testers,
  komac,
  dbus,
  zstd,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
  bzip2,
}:

let
  version = "2.10.1";
  src = fetchFromGitHub {
    owner = "russellbanks";
    repo = "Komac";
    tag = "v${version}";
    hash = "sha256-oqnFenSFWCe3vax5mqstvNNTFWOecLOkuhJzaxv78yE=";
  };
in
rustPlatform.buildRustPackage {
  inherit version src;

  pname = "komac";

  useFetchCargoVendor = true;
  cargoHash = "sha256-g7R4Vk6bFaJ5TA4IdeXRiFzZOcj1T4JY3HsOt+Zx2mU=";

  nativeBuildInputs =
    [
      pkg-config
    ]
    ++ lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
      installShellFiles
    ];

  buildInputs =
    [
      dbus
      openssl
      zstd
      bzip2
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  env = {
    OPENSSL_NO_VENDOR = true;
    YRX_REGENERATE_MODULES_RS = "no";
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/komac";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd komac \
      --bash <($out/bin/komac complete bash) \
      --zsh <($out/bin/komac complete zsh) \
      --fish <($out/bin/komac complete fish)
  '';

  passthru = {
    tests.version = testers.testVersion {
      inherit version;

      package = komac;
      command = "komac --version";
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Community Manifest Creator for WinGet";
    homepage = "https://github.com/russellbanks/Komac";
    changelog = "https://github.com/russellbanks/Komac/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      kachick
      HeitorAugustoLN
    ];
    mainProgram = "komac";
  };
}
