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
  version = "1.4.0";

  env.GOEXPERIMENT = "jsonv2";

  src = fetchFromGitHub {
    owner = "owenrumney";
    repo = "lazytrivy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mZg8hXTZhgIkPNrzP7hQ7fwMDUL9MP5kUVdg8Smq5l4=";
  };

  vendorHash = "sha256-2t6PckucJTr/2anqG8zarQOAlmGpOVvDxHkhhHfVaOo=";

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
