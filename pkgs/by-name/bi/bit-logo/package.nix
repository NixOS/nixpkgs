{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "bit-logo";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "superstarryeyes";
    repo = "bit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-czqzePH8+X4IVwuV+3L+JkDkxT5KVidybEjYKwRKZM4=";
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
    homepage = "https://github.com/superstarryeyes/bit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "bit-logo";
  };
})
