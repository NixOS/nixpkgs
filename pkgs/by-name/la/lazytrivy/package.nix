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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "owenrumney";
    repo = "lazytrivy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fhHy54pIbYdj+mWCIx7Wla6x+J/w2f8+J+WSbt+WNwA=";
  };

  vendorHash = "sha256-dIe6zjWc8DVU9YQbYfmNUcfSh6MsdZZ8/A/EYLmPNkE=";

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
