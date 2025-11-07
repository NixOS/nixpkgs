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

  cargoHash = "sha256-wpfv6mebFPvL+9UkggRRH3fPOeGslORzxtN0q/KKOsw=";

  meta = with lib; {
    description = "Command line tool for comparing benchmarks run by Criterion";
    mainProgram = "critcmp";
    homepage = "https://github.com/BurntSushi/critcmp";
    license = with licenses; [
      mit
      unlicense
    ];
    maintainers = [ ];
  };
}
