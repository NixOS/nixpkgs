{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "moq";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "matryer";
    repo = "moq";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-eVUqGAbNfLyL6ZKtVTwBJNeQ/SasgKZi/S0nGEqYBO4=";
  };

  vendorHash = "sha256-6mDFR6QZomBhlBOKmqTFlv5LlbE2upj99HMP0O5SzIk=";

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
