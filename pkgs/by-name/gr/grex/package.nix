{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "grex";
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "pemistahl";
    repo = "grex";
    rev = "v${version}";
    hash = "sha256-WBZlfp3x5r4sjKqcpckpSANBevGzT9hKHe7rTZ0Czeo=";
  };

  cargoHash = "sha256-UR+JieKyVSzjegOQqXWXYLfXy2DVpKw/ApLZwtA1ZUY=";

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/grex --help > /dev/null
  '';

  meta = {
    description = "Command-line tool for generating regular expressions from user-provided test cases";
    homepage = "https://github.com/pemistahl/grex";
    changelog = "https://github.com/pemistahl/grex/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "grex";
    maintainers = with lib.maintainers; [
      SuperSandro2000
      mfrw
    ];
  };
}
