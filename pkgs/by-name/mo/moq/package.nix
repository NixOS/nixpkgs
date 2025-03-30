{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "moq";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "matryer";
    repo = "moq";
    rev = "v${version}";
    sha256 = "sha256-Yk0lGu6wHF5OBFx/yZPJr3h3DVMvyBV8pi5eSxl7hpw=";
  };

  vendorHash = "sha256-Mwx2Z2oVFepNr911zERuoM79NlpXu13pVpXPJox86BA=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/matryer/moq";
    description = "Interface mocking tool for go generate";
    mainProgram = "moq";
    longDescription = ''
      Moq is a tool that generates a struct from any interface. The struct can
      be used in test code as a mock of the interface.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ anpryl ];
  };
}
