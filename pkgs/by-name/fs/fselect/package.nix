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
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "jhspetersson";
    repo = "fselect";
    rev = finalAttrs.version;
    sha256 = "sha256-NWEfJypalib/gSTas4TdFyHUmvqUTXm3WPKNFXQaFlI=";
  };

  cargoHash = "sha256-BZKNLOv4PtEyZUETxh4JPL0mXyV2PRrtmg4ROvVLHRY=";

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
