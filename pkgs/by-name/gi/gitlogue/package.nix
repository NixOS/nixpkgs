{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  libgit2,
  libssh2,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitlogue";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "unhappychoice";
    repo = "gitlogue";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mZ2A6274Ujpo5rTewFaMUslZhLCKJ2iw43J8X3vuBBI=";
  };

  cargoHash = "sha256-MueaRVomOiQsPSOnHpB/k9a8fNpKpFRilAXgIkVxZ94=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    libgit2
    libssh2
  ];

  env = {
    OPENSSL_NO_VENDOR = 1;
    LIBGIT2_NO_VENDOR = 1;
    LIBSSH2_SYS_USE_PKG_CONFIG = 1;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cinematic Git commit replay tool for the terminal";
    longDescription = ''
      A cinematic Git commit replay tool for the terminal, turning your Git history into a living, animated story.
    '';
    homepage = "https://github.com/unhappychoice/gitlogue";
    changelog = "https://github.com/unhappychoice/gitlogue/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ chillcicada ];
    mainProgram = "gitlogue";
  };
})
