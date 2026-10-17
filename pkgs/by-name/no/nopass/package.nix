{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  git,
  pkg-config,
  udev,
  # The FIDO2 security-key slot pulls in a C HID stack. Off by default,
  # exactly as in Cargo.toml.
  withSecurityKey ? false,
}:

rustPlatform.buildRustPackage rec {
  pname = "nopass";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "souravsspace";
    repo = "nopass";
    tag = "v${version}";
    hash = "sha256-b2H7xPI5Nt2Zwe4YGpigvxh/OFfPw5Gq54dRKuB3lU8=";
  };

  cargoHash = "sha256-zmDWXbcjraMfizO4vYTVeH2gKWbb75FK7vACNV92qzo=";

  cargoBuildFlags = [
    "--package"
    "nopass-cli"
  ];
  buildFeatures = lib.optional withSecurityKey "security-key";

  nativeBuildInputs = lib.optionals withSecurityKey [ pkg-config ];
  buildInputs = lib.optionals (withSecurityKey && stdenv.hostPlatform.isLinux) [ udev ];

  # The history and sync tests drive a real git, and every test wants a HOME
  # of its own to keep away from the one running the build.
  nativeCheckInputs = [ git ];
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = {
    description = "Fast, self-contained password manager";
    longDescription = ''
      nopass keeps each password in its own age-encrypted file under one
      directory. Every command that reads or changes the store asks for your
      master passphrase; reads can reuse a cached one when you opt in.
    '';
    homepage = "https://github.com/souravsspace/nopass";
    changelog = "https://github.com/souravsspace/nopass/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ souravsspace ];
    mainProgram = "nopass";
    platforms = lib.platforms.unix;
  };
}
