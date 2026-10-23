{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  versionCheckHook,
  wl-mirror,
}:

buildGoModule (finalAttrs: {
  pname = "nirimon";
  version = "2026.819.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "stepbrobd";
    repo = "nirimon";
    tag = finalAttrs.version;
    hash = "sha256-3fh0oNStHCOwjht+rCvJ4RTuSLqAKvjF+b8KXf89kaU=";
  };

  vendorHash = "sha256-eSKuDWtzRxwrRvBKA6z85P/+Lqf7djgqMVu3xv7ttDM=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/nirimon --prefix PATH : "${lib.makeBinPath [ wl-mirror ]}"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI monitor configuration tool for niri with visual layout, drag-and-drop, and profile management";
    homepage = "https://github.com/stepbrobd/nirimon";
    license = lib.licenses.asl20;
    mainProgram = "nirimon";
    maintainers = with lib.maintainers; [ stepbrobd ];
    platforms = lib.platforms.linux;
  };
})
