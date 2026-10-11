{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gh-attach";
  version = "0.4.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sudosubin";
    repo = "gh-attach";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pe0lzjSI19QsFhQ4MnDFEzIFi2zoZU8lM9AI7fMX7CU=";
  };

  vendorHash = "sha256-q4ZI6sCbId0TTJQwrPOQC0pse4tqegK+btoQ4PUcAOE=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/sudosubin/gh-attach/releases/tag/${finalAttrs.src.rev}";
    description = "GitHub CLI extension to upload and download images and files as user-attachments";
    longDescription = ''
      Uploads a local file such as a screenshot, image, PDF, zip, or video to
      GitHub user-attachments, downloads GitHub user-attachments, and embeds
      local files in a pull request, issue, or comment.
    '';
    homepage = "https://github.com/sudosubin/gh-attach";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sudosubin ];
    mainProgram = "gh-attach";
  };
})
