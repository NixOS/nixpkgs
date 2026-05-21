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
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "jhspetersson";
    repo = "fselect";
    rev = finalAttrs.version;
    sha256 = "sha256-2YLWFUDwmurQAkoYB0KNjCEhwDNAUIAkgw6+lpU7DDA=";
  };

  cargoHash = "sha256-7dyMzlrlhU4yuEd9sNce2QoIB8dWjpcNr0mnIZxjC3U=";

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
