{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lucida-downloader";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "jelni";
    repo = "lucida-downloader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7mq6xoafXqhqhe9vLdc67aGzlUrD8hTyCGkIyqndfPA=";
  };

  passthru.updateScript = nix-update-script { };

  cargoHash = "sha256-lUxPPykO/U7bVgtw3yGxqD0PbqHng5bIW0krvYW7+Kw=";

  meta = {
    description = "Multithreaded client for downloading music for free with lucida";
    homepage = "https://github.com/jelni/lucida-downloader";
    license = lib.licenses.agpl3Plus;
    mainProgram = "lucida";
    maintainers = with lib.maintainers; [
      jelni
      surfaceflinger
    ];
  };
})
