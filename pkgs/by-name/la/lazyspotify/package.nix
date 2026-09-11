{
  buildGoModule,
  callPackage,
  fetchFromGitHub,
  lib,
  versionCheckHook,
  customKeyring ? null,
}:
buildGoModule (finalAttrs: {
  pname = "lazyspotify";
  version = "0.5.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dubeyKartikay";
    repo = "lazyspotify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P7Zon1O3YlD6Rga53DJA0Dap7qAcj8G6RaBi/3XWjAI=";
  };

  vendorHash = "sha256-Axdt3/3ZOZY9Z5VUI6Wh77oIREOO26ODMyEgtscTmn8=";

  subPackages = [ "cmd/lazyspotify" ];

  # lets me use oo7 with /org/freedesktop/secrets/collection/Login
  # unsure why its needed tbh but fails without
  preBuild = lib.optionalString (customKeyring != null) ''
    chmod -R u+w vendor/github.com/zalando/go-keyring
    substituteInPlace vendor/github.com/zalando/go-keyring/secret_service/secret_service.go \
      --replace-fail '/org/freedesktop/secrets/aliases/default' '${customKeyring}'
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/dubeyKartikay/lazyspotify/buildinfo.Version=${finalAttrs.version}"
    "-X github.com/dubeyKartikay/lazyspotify/buildinfo.PackagedDaemonPath=${
      lib.getExe (callPackage ./go-librespot.nix { })
    }"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Terminal Spotify client for macOS and Linux";
    homepage = "https://dubeykartikay.github.io/lazyspotify/";
    changelog = "https://github.com/dubeyKartikay/lazyspotify/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "lazyspotify";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      eConnah
    ];
  };
})
