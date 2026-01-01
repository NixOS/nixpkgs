{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "nix-converter";
<<<<<<< HEAD
  version = "0-unstable-2025-12-29";
=======
  version = "0-unstable-2025-04-14";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "theobori";
    repo = "nix-converter";
<<<<<<< HEAD
    rev = "6e5c00e94f078a1eea610e736e7e1fb8349b1ab5";
    hash = "sha256-Pdw/vUgfEws+EOyFT9WK8SjZP6DCVJkWWJgI01+5+KI=";
=======
    rev = "d06af43bf578f2650417600250e68782478ce98d";
    hash = "sha256-/HEKbE1tLCGGu4xopky/02OWRt23UUTPKQCdi7ThCX8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
