{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "lrcsnc";
  version = "0.1.3-1";

  src = fetchFromGitHub {
    owner = "Endg4meZer0";
    repo = "lrcsnc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/lDOWxPl9Z6LellbbuGMNMhiqQfulKmogQ/KnlGus3g=";
  };

  vendorHash = "sha256-33BiLjmMcPAyd0SEGA24MnaW74L764bcU1A6s1pl3+8=";

  ldflags = [ "-X lrcsnc/internal/setup.version=${finalAttrs.version}" ];

  # The tests require network access
  doCheck = false;

  postInstall = ''
    install -Dm644 LICENSE $out/share/licenses/lrcsnc/LICENSE
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Player-agnostic synced lyrics fetcher and displayer";
    homepage = "https://github.com/Endg4meZer0/lrcsnc";
    mainProgram = "lrcsnc";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ lonerOrz ];
  };
})
