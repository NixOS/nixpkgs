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
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "jhspetersson";
    repo = "fselect";
    rev = version;
    sha256 = "sha256-6TKCasE+Cks/f716mtEnPOvjcbQ7weipbGfFwnBYXJk=";
  };

  cargoHash = "sha256-2DmfbQWyU+1vNKxZvDw92Rh5rxFifeKEglZSV2YNfdA=";

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
    maintainers = with maintainers; [
      Br1ght0ne
      matthiasbeyer
    ];
    mainProgram = "fselect";
  };
}
