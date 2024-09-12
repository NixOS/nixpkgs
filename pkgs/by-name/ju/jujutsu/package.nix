{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  zstd,
  libgit2,
  libssh2,
  openssl,
  darwin,
  libiconv,
  git,
  gnupg,
  openssh,
  buildPackages,
  nix-update-script,
  testers,
  jujutsu,
}:

let
  version = "0.21.0";
in

rustPlatform.buildRustPackage {
  pname = "jujutsu";
  inherit version;

  src = fetchFromGitHub {
    owner = "martinvonz";
    repo = "jj";
    rev = "v${version}";
    hash = "sha256-uZsfHhcYpobatWaDQczuc9Z3BWHN5VO0qr/8mu5kEio=";
  };

  cargoHash = "sha256-BOO1jP1Y5CNbE97zj+tpariiBdcuxKb1wyvI7i/VpYI=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs =
    [
      zstd
      libgit2
      libssh2
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
      libiconv
    ];

  nativeCheckInputs = [
    git
    gnupg
    openssh
  ];

  cargoBuildFlags = [
    # Don’t install the `gen-protos` build tool.
    "--bin"
    "jj"
  ];

  useNextest = true;

  cargoTestFlags = [
    # Don’t build the `gen-protos` build tool when running tests.
    "-p"
    "jj-lib"
    "-p"
    "jj-cli"
  ];

  env = {
    # Disable vendored libraries.
    ZSTD_SYS_USE_PKG_CONFIG = "1";
    LIBGIT2_NO_VENDOR = "1";
    LIBSSH2_SYS_USE_PKG_CONFIG = "1";
  };

  postInstall =
    let
      jj = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/jj";
    in
    lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
      ${jj} util mangen > ./jj.1
      installManPage ./jj.1

      installShellCompletion --cmd jj \
        --bash <(${jj} util completion bash) \
        --fish <(${jj} util completion fish) \
        --zsh <(${jj} util completion zsh)
    '';

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      version = testers.testVersion {
        package = jujutsu;
        command = "jj --version";
      };
    };
  };

  meta = {
    description = "Git-compatible DVCS that is both simple and powerful";
    homepage = "https://github.com/martinvonz/jj";
    changelog = "https://github.com/martinvonz/jj/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      _0x4A6F
      thoughtpolice
      emily
      bbigras
    ];
    mainProgram = "jj";
  };
}
