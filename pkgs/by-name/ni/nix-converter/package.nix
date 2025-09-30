{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "nix-converter";
  version = "0-unstable-2025-04-14";

  src = fetchFromGitHub {
    owner = "theobori";
    repo = "nix-converter";
    rev = "d06af43bf578f2650417600250e68782478ce98d";
    hash = "sha256-/HEKbE1tLCGGu4xopky/02OWRt23UUTPKQCdi7ThCX8=";
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
