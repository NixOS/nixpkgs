{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "nix-converter";
  version = "0-unstable-2025-12-29";

  src = fetchFromGitHub {
    owner = "theobori";
    repo = "nix-converter";
    rev = "6e5c00e94f078a1eea610e736e7e1fb8349b1ab5";
    hash = "sha256-Pdw/vUgfEws+EOyFT9WK8SjZP6DCVJkWWJgI01+5+KI=";
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
}
