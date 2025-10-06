{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "grex";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "pemistahl";
    repo = "grex";
    rev = "v${version}";
    hash = "sha256-Ut2H2H66XN1+wHpYivnuhil21lbd7bwIcIcMyIimdis=";
  };

  cargoHash = "sha256-OsK6X7qwMMQ1FK3JE98J2u6pn6AixE8izFmxUVDs5GM=";

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
