{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-admonish";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "tommilligan";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-GNQIOjgHCt3XPCzF0RjV9YStI8psLdHhTPuTkdgx8vA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-GbXLlWHbLL7HbyuX223S/o1/+LwbK8FjL7lnEgVVn00=";

  meta = {
    description = "Preprocessor for mdbook to add Material Design admonishments";
    mainProgram = "mdbook-admonish";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jmgilman
      Frostman
      matthiasbeyer
    ];
    homepage = "https://github.com/tommilligan/mdbook-admonish";
  };
}
