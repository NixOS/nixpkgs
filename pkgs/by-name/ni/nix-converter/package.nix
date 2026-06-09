{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "nix-converter";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "theobori";
    repo = "nix-converter";
    tag = finalAttrs.version;
    hash = "sha256-RfZcQsDPZJZXggvjF0JQqUXg5p2WnMjYANkDXkQZIhU=";
  };

  vendorHash = "sha256-Ay1f9sk8RuJyOS7hl/lrscpxdlIgm9dMow/xTFoR+H4=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "All-in-one converter configuration language to Nix and vice versa";
    homepage = "https://github.com/theobori/nix-converter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      theobori
      jaredmontoya
    ];
    mainProgram = "nix-converter";
  };
})
