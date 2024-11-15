{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "package-assistant";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "patryk-s";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-Pd5ONAqqBaOaxF5/SvtE9lNvweCzzbjC7fVj+IKTIoQ=";
  };

  cargoHash = "sha256-Ct8XvFIj6R8ZMG4s98rO0vfqpKln8Y3Vhhe78a0h9Bo=";

  meta = {
    description = "Manage your package managers";
    longDescription = ''
      Provides a consistent CLI interface for all supported package managers,
      across multiple OSes, so you don't have to remember the specific syntax on a given system.
    '';
    homepage = "https://github.com/patryk-s/package-assistant";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ patryk-s ];
    mainProgram = "pa";
  };
}
