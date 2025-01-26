{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pup";
  version = "unstable-2022-03-06";

  src = fetchFromGitHub {
    owner = "ericchiang";
    repo = "pup";
    rev = "5a57cf111366c7c08999a34b2afd7ba36d58a96d";
    hash = "sha256-Ledg3xPbu71L5qUY033bru/lw03jws3s4YlAarIuqaA=";
  };

  vendorHash = "sha256-/MDSWIuSYNxKbTslqIooI2qKA8Pye0yJF2dY8g8qbWI=";

  meta = with lib; {
    description = "Parsing HTML at the command line";
    mainProgram = "pup";
    homepage = "https://github.com/ericchiang/pup";
    license = licenses.mit;
    maintainers = [ ];
  };
}
