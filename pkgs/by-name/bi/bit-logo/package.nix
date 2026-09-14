{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "bit-logo";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "paulilaaso";
    repo = "bit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CCRJFxVHe7FNGX5XC2SYWAzcMVNlHjUBt0El41Zo9Ww=";
  };

  vendorHash = "sha256-Zxw0NyZfM42ytn+vDExLwRgNLWsdGVLC3iNVpQd8VMw=";

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
    homepage = "https://github.com/paulilaaso/bit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "bit-logo";
  };
})
