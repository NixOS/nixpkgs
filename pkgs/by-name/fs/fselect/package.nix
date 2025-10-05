{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  pname = "fselect";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "jhspetersson";
    repo = "fselect";
    rev = version;
    sha256 = "sha256-uR0AElAjzvxymA9K/JySfYpPK59G2SaLTfZpdFtTg/g=";
  };

  cargoHash = "sha256-j/c2+I/KIYgNxYiHE2oWIq5frNPFtXE5wELWsog8dsc=";

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;

  postInstall = ''
    installManPage docs/fselect.1
  '';

  meta = with lib; {
    description = "Find files with SQL-like queries";
    homepage = "https://github.com/jhspetersson/fselect";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ Br1ght0ne ];
    mainProgram = "fselect";
  };
}
