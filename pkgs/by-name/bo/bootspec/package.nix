{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "bootspec";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = "bootspec";
    rev = "v${version}";
    hash = "sha256-0MO+SqG7Gjq+fmMJkIFvaKsfTmC7z3lGfi7bbBv7iBE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-fKbF5SyI0UlZTWsygdE8BGWuOoNSU4jx+CGdJoJFhZs=";

  meta = with lib; {
    description = "Implementation of RFC-0125's datatype and synthesis tooling";
    homepage = "https://github.com/DeterminateSystems/bootspec";
    license = licenses.mit;
    teams = [ teams.determinatesystems ];
    platforms = platforms.unix;
  };
}
