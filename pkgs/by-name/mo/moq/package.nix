{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "moq";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "matryer";
    repo = "moq";
    rev = "v${version}";
    sha256 = "sha256-veAfQ9dFt6s6xQace0nkcbAirl98UekJx+0qPHnQVGg=";
  };

  vendorHash = "sha256-Mwx2Z2oVFepNr911zERuoM79NlpXu13pVpXPJox86BA=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/matryer/moq";
    description = "Interface mocking tool for go generate";
    mainProgram = "moq";
    longDescription = ''
      Moq is a tool that generates a struct from any interface. The struct can
      be used in test code as a mock of the interface.
    '';
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anpryl ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ anpryl ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
