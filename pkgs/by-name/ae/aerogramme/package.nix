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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "deuxfleurs-org";
    repo = "aerogramme";
    tag = finalAttrs.version;
    hash = "sha256-Ec3EaBnrdL1gU2oKSfNmJyRJwxv4AH74q+Qv/wZlaBc=";
  };

  # git.deuxfleurs.fr is not letting shallow clones of commits and getting timedout
  postUnpack = ''
    substituteInPlace "$sourceRoot/Cargo.lock" \
      --replace-fail "https://git.deuxfleurs.fr/Deuxfleurs/garage.git" "https://github.com/deuxfleurs-org/garage.git"
    substituteInPlace "$sourceRoot/Cargo.toml" \
      --replace-fail "https://git.deuxfleurs.fr/Deuxfleurs/garage.git" "https://github.com/deuxfleurs-org/garage.git"
  '';

  patches = [
    # remove once https://git.deuxfleurs.fr/Deuxfleurs/aerogramme/pulls/211 is available
    # not using fetchpatch because git.deuxfleurs.fr frequently times out.
    ./fix-unselect-test-race.patch
  ];

  cargoHash = "sha256-oJS/OCDcjW9eLprr43uQByNv/p8z3Dh+D2ItgazP74g=";

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
