{
  lib,
  buildGoModule,
  fetchFromGitHub,
  callPackage,
}:
buildGoModule (finalAttrs: {
  pname = "donetick";
  version = "0.1.76";

  src = fetchFromGitHub {
    owner = "donetick";
    repo = "donetick";
    tag = "v${finalAttrs.version}";
    hash = "sha256-erko77j6yPmDbEO0pxYu7GQLzKEAFOXn8ZcAccENjew=";
  };

  vendorHash = "sha256-4Ho9lIWk80k+6wVCk27EPYdD7eDC0SUXR9PcIAVmBRA=";

  __structuredAttrs = true;

  postPatch = ''
    rm -rf frontend/dist
    cp -r ${finalAttrs.passthru.frontend} frontend/dist
  '';

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X donetick.com/core/config.Version=v${finalAttrs.version}"
    "-X donetick.com/core/config.Commit=${finalAttrs.src.rev}"
  ];

  postInstall = ''
    mv $out/bin/core $out/bin/donetick
  '';

  passthru = {
    frontend = callPackage ./frontend.nix { };
    updateScript = ./update.sh;
  };

  meta = {
    description = "Self-hosted, user-friendly app for managing tasks and chores";
    longDescription = ''
      Donetick is an open-source, user-friendly app for managing tasks and
      chores, with customizable scheduling, assignee rotation, gamification,
      and notification integrations (Telegram, Discord, Pushover). This
      package bundles the donetick/frontend web UI, embedded into the Go
      binary, matching the upstream Docker image.
    '';
    homepage = "https://donetick.com";
    changelog = "https://github.com/donetick/donetick/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    mainProgram = "donetick";
    maintainers = with lib.maintainers; [ lykos153 ];
    platforms = lib.platforms.linux;
  };
})
