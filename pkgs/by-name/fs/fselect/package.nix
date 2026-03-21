{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  libiconv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fselect";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "jhspetersson";
    repo = "fselect";
    rev = finalAttrs.version;
    sha256 = "sha256-NNDWKjO0A6ETIC+6Eg6LqyrwwErbP8362YzzNJYgtlE=";
  };

  cargoHash = "sha256-lDN3b5skS5+e1Lz3StBqW+yTN2dVxy9bWZ5z69o5z7s=";

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;

  postInstall = ''
    installManPage docs/fselect.1
  '';

  meta = {
    description = "Find files with SQL-like queries";
    homepage = "https://github.com/jhspetersson/fselect";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
    mainProgram = "fselect";
  };
})
