{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cloudflare-speed-cli";
  version = "1.0.8";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kavehtehrani";
    repo = "cloudflare-speed-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zEnl8Xd23RzRzV2VhUUfMPubhT3SnvBpwDo4oNV/x98=";
  };

  cargoHash = "sha256-2kVzz86g+ctoHSpllB2n+jf1izSgixG0yaUtxWqYXCE=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "cloudflare-speed-cli";
    description = "CLI for internet speed test via cloudflare";
    longDescription = ''
      A CLI tool that displays network speed test results from
      Cloudflare's speed test service in a TUI interface.
    '';
    homepage = "https://github.com/kavehtehrani/cloudflare-speed-cli";
    downloadPage = "https://github.com/kavehtehrani/cloudflare-speed-cli/releases/tag/${finalAttrs.src.tag}";
    changelog = "https://github.com/kavehtehrani/cloudflare-speed-cli/commits/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    identifiers = {
      cpeParts = lib.meta.cpeFullVersionWithVendor "kavehtehrani" finalAttrs.version;
      purlParts = {
        type = "github";
        namespace = "kavehtehrani";
        name = "cloudflare-speed-cli";
        version = finalAttrs.version;
      };
    };
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ KristijanZic ];
  };
})
