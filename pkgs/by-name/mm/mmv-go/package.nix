{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mmv-go";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "itchyny";
    repo = "mmv";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-DNLiW0QX7WrBslwVCbvydLnE6JAcfcRALYqwsK/J5x0=";
  };

  vendorHash = "sha256-HHGiMSBu3nrIChSYaEu9i22nwhLKgVQkPvbTMHBWwAE=";

  ldflags = [
    "-s"
    "-w"
    "-X main.revision=${finalAttrs.src.rev}"
  ];

  meta = {
    homepage = "https://github.com/itchyny/mmv";
    description = "Rename multiple files using your $EDITOR";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "mmv";
  };
})
