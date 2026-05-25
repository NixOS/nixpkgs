{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "moq";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "matryer";
    repo = "moq";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-IJnP8aF0UJTEDlayZtxe0Qqs3RFTKT7O5ZiGtaULCMM=";
  };

  vendorHash = "sha256-Mwx2Z2oVFepNr911zERuoM79NlpXu13pVpXPJox86BA=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  meta = {
    homepage = "https://github.com/matryer/moq";
    description = "Interface mocking tool for go generate";
    mainProgram = "moq";
    longDescription = ''
      Moq is a tool that generates a struct from any interface. The struct can
      be used in test code as a mock of the interface.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anpryl ];
  };
})
