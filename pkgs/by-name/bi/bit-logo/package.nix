{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "bit-logo";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "superstarryeyes";
    repo = "bit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VpAunQUttuuC+yrACD8piqKbiiTaAfKdJ/ZthvQijXI=";
  };

  vendorHash = "sha256-ZQ5SbjQPngVUgGklADfNSM43ks3948ilDKdmxh2sq6A=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal ANSI Logo Designer & Font Library";
    longDescription = ''
      CLI/TUI logo designer + ANSI font library with gradient colors,
      shadows, and multi-format export.
    '';
    homepage = "https://github.com/superstarryeyes/bit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "bit-logo";
  };
})
