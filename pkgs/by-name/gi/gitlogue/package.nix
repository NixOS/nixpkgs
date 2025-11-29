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
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "unhappychoice";
    repo = "gitlogue";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SkdyOEMN4neW/KHf5nuBh3e5CJ2Vrul/1ydOhpK1Rdg=";
  };

  cargoHash = "sha256-RIs7pf+S01nupYzOIferlh+c/NuNHgBTspx+9MGl33g=";

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
