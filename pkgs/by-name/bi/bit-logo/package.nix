{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "bit-logo";
<<<<<<< HEAD
  version = "0.3.0";
=======
  version = "0.1.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "superstarryeyes";
    repo = "bit";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-iLwWKn8csoRkr5H8R2kpZVZCxsL0LDWHNvNoxyM6y98=";
  };

  vendorHash = "sha256-Zxw0NyZfM42ytn+vDExLwRgNLWsdGVLC3iNVpQd8VMw=";
=======
    hash = "sha256-VpAunQUttuuC+yrACD8piqKbiiTaAfKdJ/ZthvQijXI=";
  };

  vendorHash = "sha256-ZQ5SbjQPngVUgGklADfNSM43ks3948ilDKdmxh2sq6A=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
