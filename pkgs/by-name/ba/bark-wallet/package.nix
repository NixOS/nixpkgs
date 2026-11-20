{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  protobuf,
  openssl,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bark-wallet";
  version = "0.7.1";

  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "ark-bitcoin";
    repo = "bark";
    tag = "bark-${finalAttrs.version}";
    hash = "sha256-nHoMhOqAVPjMePqKrJLuZxBIjHstA+AHLc0b/T/pnfQ=";
  };

  cargoHash = "sha256-Wsr4QIjY6HWvIW5y4H4p0rGllP9cQF0kHlw12kPLstM=";

  # Disable barkd's default Swagger UI feature, whose build script downloads
  # web assets. Re-enable native TLS roots, the other bark-cli default feature.
  buildNoDefaultFeatures = true;
  buildFeatures = [ "bark-cli/tls-native-roots" ];

  cargoBuildFlags = [
    "--package=bark-cli"
    "--package=bark-server"
    "--bin=bark"
    "--bin=barkd"
    "--bin=captaind"
    "--bin=watchmand"
  ];

  # The separate ark-testing workspace member needs running Bitcoin,
  # Lightning and PostgreSQL daemons. Run the CLI and server unit tests.
  cargoTestFlags = [
    "--package=bark-cli"
    "--package=bark-server"
    "--lib"
    "--bins"
  ];

  nativeBuildInputs = [
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
    sqlite
  ];

  env = {
    BARK_VERSION = finalAttrs.version;
    SERVER_VERSION = finalAttrs.version;
    GIT_HASH = finalAttrs.src.rev;
    OPENSSL_NO_VENDOR = true;
  };

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  installCheckPhase = ''
    runHook preInstallCheck

    for program in bark barkd captaind watchmand; do
      "$out/bin/$program" --version | grep -F '${finalAttrs.version}'
    done

    runHook postInstallCheck
  '';

  meta = {
    description = "Bitcoin Ark wallet and server built by Second";
    homepage = "https://gitlab.com/ark-bitcoin/bark";
    changelog = "https://gitlab.com/ark-bitcoin/bark/-/releases/bark-${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prusnak ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "bark";
  };
})
