{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "agent-usage";
  version = "0.1.4";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "raine";
    repo = "tmux-agent-usage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iNXAx+hPjtNoUrAPFQZmZfFbXUgsGbqXsqHIDV4I5Ak=";
  };

  cargoHash = "sha256-Z5+4A8uZe3TwtyH7xM646MyvHM3JY4hTzStCHx0o4Bw=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Display AI agent rate limit usage in your tmux status bar";
    homepage = "https://github.com/raine/tmux-agent-usage";
    changelog = "https://github.com/raine/tmux-agent-usage/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "agent-usage";
    maintainers = with lib.maintainers; [ sei40kr ];
    platforms = lib.platforms.unix;
  };
})
