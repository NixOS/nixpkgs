{
  lib,
  fetchFromGitea,
  rustPlatform,
  pkg-config,
  git,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fedigroups";
  version = "0.4.6";

  src = fetchFromGitea {
    domain = "git.ondrovo.com";
    owner = "MightyPork";
    repo = "group-actor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Sq22CwLLR10yrN3+dR2KDoS8r99+LWOH7+l+D3RWlKw=";
    forceFetchGit = true; # Archive generation is disabled on this gitea instance
    leaveDotGit = true; # git command in build.rs
  };

  cargoHash = "sha256-6UijHshvKANtMMfNADWDViDrh6bGlPvFz4xqJeWdqB0=";

  nativeBuildInputs = [
    pkg-config
    git
  ];

  buildInputs = [
    openssl
  ];

  meta = {
    homepage = "https://git.ondrovo.com/MightyPork/group-actor#fedi-groups";
    downloadPage = "https://git.ondrovo.com/MightyPork/group-actor/releases";
    description = "Approximation of groups usable with Fediverse software that implements the Mastodon client API";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
    mainProgram = "fedigroups";
  };
})
