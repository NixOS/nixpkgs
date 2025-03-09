{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "critcmp";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "critcmp";
    rev = version;
    hash = "sha256-cf78R9siH0RFbx+vXTs71VblpsQokL6Uo32N3X4lV2I=";
  };

  cargoHash = "sha256-yzWa+/08tG8h+5V8XBc3k8GDivS6SHW6zVb+ug1sbE0=";

  meta = with lib; {
    description = "Command line tool for comparing benchmarks run by Criterion";
    mainProgram = "critcmp";
    homepage = "https://github.com/BurntSushi/critcmp";
    license = with licenses; [
      mit
      unlicense
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
