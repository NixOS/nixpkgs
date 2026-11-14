{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  openssl,
  libsodium,
  aws-lc,
  zstd,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aerogramme";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "deuxfleurs-org";
    repo = "aerogramme";
    tag = finalAttrs.version;
    hash = "sha256-YNCTrEH7/p//q8HmWJZ1smtWJVcisVmlC/Eh7AOlU2M=";
  };

  # git.deuxfleurs.fr is not letting shallow clones of commits and getting timedout
  postUnpack = ''
    substituteInPlace "$sourceRoot/Cargo.lock" \
      --replace-fail "https://git.deuxfleurs.fr/Deuxfleurs/garage.git" "https://github.com/deuxfleurs-org/garage.git"
    substituteInPlace "$sourceRoot/Cargo.toml" \
      --replace-fail "https://git.deuxfleurs.fr/Deuxfleurs/garage.git" "https://github.com/deuxfleurs-org/garage.git"
  '';

  cargoHash = "sha256-6saVYAUoIs1gI2JCXLUZjEQru4o+D4TzD3SY/Tnaf2c=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    libsodium
    aws-lc
    zstd
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Encrypted e-mail storage over Garage";
    homepage = "https://aerogramme.deuxfleurs.fr/";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ supinie ];
    teams = with lib.teams; [ ngi ];
    mainProgram = "aerogramme";
    platforms = lib.platforms.linux;
  };
})
