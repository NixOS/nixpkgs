{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ratatouille";
  version = "0.90.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dappermint";
    repo = "ratatouille";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yzSrI93yRESEPScxh1VyxsYzLBJIfJQLA4VP208vIO8=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  postInstall = ''
    ln -s ratatouille "$out/bin/rat"
  '';

  meta = {
    description = "Whole-surface macOS storage accounting and cleanup TUI";
    longDescription = ''
      Terminal app that accounts for every byte of a Mac's storage instead of
      listing findings. It maps the APFS containers, walks the data volume with
      a device-bounded scan where each level sums to its parent, names the space
      it could not read rather than dropping it, and reports filesystem health
      from SMART and NVMe error counters. Cleanup uses each tool's own supported
      command and moves path-based removals to Trash.
    '';
    homepage = "https://github.com/dappermint/ratatouille";
    changelog = "https://github.com/dappermint/ratatouille/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "ratatouille";
    maintainers = with lib.maintainers; [ dappermint ];
    platforms = lib.platforms.darwin;
  };
})
