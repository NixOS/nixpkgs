{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "kino-tui";
  version = "0.7.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mmcdole";
    repo = "kino";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sVfEqICSo0ZYH0kUnRNQJRUStlfyk4E0JFgchSwm7YM=";
  };

  vendorHash = "sha256-XNuGyFn1NEfffKA19NhMeXWRpSnoWp17NTlL2m1xqW0=";

  subPackages = [ "cmd/kino" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=v${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal client for browsing and playing Plex or Jellyfin media";
    homepage = "https://github.com/mmcdole/kino";
    changelog = "https://github.com/mmcdole/kino/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "kino";
    maintainers = with lib.maintainers; [
      notaclementine
    ];
  };
})
