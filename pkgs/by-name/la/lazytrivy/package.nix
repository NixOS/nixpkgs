{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  trivy,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "lazytrivy";
  version = "1.3.3";

  env.GOEXPERIMENT = "jsonv2";

  src = fetchFromGitHub {
    owner = "owenrumney";
    repo = "lazytrivy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M7qhkHuyI6cpmRzvn8AJun3tyzTbU8QtUlK7Qo0xxU4=";
  };

  vendorHash = "sha256-vzdGWlyk4Eqhh+r4RH4eVVA4YPnADCGYnh0tmeD8S8M=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/lazytrivy \
      --prefix PATH : ${
        lib.makeBinPath [
          trivy
        ]
      }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI to do vulnerability scanning using trivy";
    homepage = "https://github.com/owenrumney/lazytrivy";
    changelog = "https://github.com/owenrumney/lazytrivy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "lazytrivy";
  };
})
