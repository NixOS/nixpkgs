{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "lrcsnc";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "Endg4meZer0";
    repo = "lrcsnc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U1wq3x9GkwJYoR7jA3EtRcFd6UkMf5UGWuBeG+6DYLY=";
  };

  vendorHash = "sha256-ww+SXy29woGlb120sj1oGb4MIQJzpBCKGpUKYsYxTMk=";

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
