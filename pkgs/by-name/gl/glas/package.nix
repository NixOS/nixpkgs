{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "glas";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "maurobalbi";
    repo = "glas";
    rev = "v${version}";
    sha256 = "sha256-jMpFxzosaCedwsJ8URlR3Gd/mnlgSBEfA3oIymmEPFU=";
  };

  cargoHash = "sha256-zESRtefoObpUsu4RfTsqJAyBNylouXffpNK3W/X+w9M=";

  doInstallCheck = true;
  postInstallCheck = ''
    $out/bin/glas --help > /dev/null
  '';

  meta = {
    description = "Language server for the Gleam programming language";
    homepage = "https://github.com/maurobalbi/glas";
    changelog = "https://github.com/maurobalbi/glas/tag/v${version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "glas";
    maintainers = with lib.maintainers; [ bhankas ];
  };
}
