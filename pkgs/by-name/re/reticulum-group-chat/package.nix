{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "reticulum-group-chat";
  version = "1.11.0";
  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "thatSFguy";
    repo = "reticulum-group-chat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LWHYIKnkEPrlDIEruP2ctuMQGnrL1uofOWAsZ4E5guw=";
  };

  vendorHash = "sha256-qMmEi7OYv2xzYOoeBWQ0omeIrcTyhxylw2qvv9kd9dk=";

  ldflags = [ "-s" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pure-Go LXMF group-chat hub for the Reticulum network — a single static binary that relays many-to-many encrypted text chat over LoRa, TCP/IP, and mixed meshes. No Python, no third-party RNS library";
    homepage = "https://github.com/thatSFguy/reticulum-group-chat";
    changelog = "https://github.com/thatSFguy/reticulum-group-chat/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "fwdsvc";
  };
})
