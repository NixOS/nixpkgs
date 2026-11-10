{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  stdenv,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "surge-downloader";
  version = "0.12.4";

  src = fetchFromGitHub {
    owner = "SurgeDM";
    repo = "Surge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/i6MBfi0Btl32Wz3iVU9QjTf7Y3xOodiXJ6Ix/dcCQU=";
  };

  vendorHash = "sha256-+L0Pq4+d5rgVsoV17991TWkloEFg7ohde6UCpl0NBlY=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-X github.com/SurgeDM/Surge/cmd.Version=${finalAttrs.version}"
  ];

  postInstall =
    if stdenv.hostPlatform.isDarwin then
      ''
        mv $out/bin/Surge $out/bin/surge.tmp
        mv $out/bin/surge.tmp $out/bin/surge
      ''
    else
      ''
        mv $out/bin/Surge $out/bin/surge
        ln -s $out/bin/surge $out/bin/Surge
      '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "TUI download manager";
    longDescription = ''
      Surge is a blazing fast, open-source terminal (TUI) download manager built in Go.
      Designed for power users who prefer a keyboard-driven workflow. It features a beautiful TUI,
      as well as a background Headless Server and a CLI tool for automation.
    '';
    homepage = "https://github.com/SurgeDM/Surge";
    changelog = "https://github.com/SurgeDM/Surge/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "surge";
    maintainers = with lib.maintainers; [ ErmitaVulpe ];
  };
})
