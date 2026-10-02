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
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "SurgeDM";
    repo = "Surge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LojzHquVeXAI8/k5qYSdGExWw/Y6sgVRNjNagRot5gY=";
  };

  vendorHash = "sha256-Z1eNKci0MzXvKs49kOEYXr/JEO7AJB9kHdFTyNbxkw4=";

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
