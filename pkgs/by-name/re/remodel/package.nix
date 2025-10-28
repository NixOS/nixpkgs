{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "remodel";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "rojo-rbx";
    repo = "remodel";
    rev = "v${version}";
    sha256 = "sha256-tZ6ptGeNBULJaoFomMFN294wY8YUu1SrJh4UfOL/MnI=";
  };

  cargoHash = "sha256-41EkXciQZ7lGlD+gVlZEahrGPeEMmaIaiF7tYff9xXw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = {
    description = "Roblox file manipulation tool";
    mainProgram = "remodel";
    longDescription = ''
      Remodel is a command line tool for manipulating Roblox files and the instances contained within them.
    '';
    homepage = "https://github.com/rojo-rbx/remodel";
    downloadPage = "https://github.com/rojo-rbx/remodel/releases/tag/v${version}";
    changelog = "https://github.com/rojo-rbx/remodel/raw/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
