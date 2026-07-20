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
  version = "1.4.1";

  env.GOEXPERIMENT = "jsonv2";

  src = fetchFromGitHub {
    owner = "owenrumney";
    repo = "lazytrivy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0VWmsZKp0IEQ93AuMoYXN8pF0G3fwaP7Lzh3JsN2CtU=";
  };

  vendorHash = "sha256-HKD7vpQAw3G4uMLUMhbv6tsFCOxfp62Phynun4HkFrg=";

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
