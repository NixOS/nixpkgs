{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "moq";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "matryer";
    repo = "moq";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-lIYRzDzZ/p74ZBTVViuPTfexZZgkpFK4wcjh9D/DoMc=";
  };

  vendorHash = "sha256-v1EImmEZGNE1RVT1ZRRgkcGD/gtZZky6E9LRtmRUyJM=";

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
