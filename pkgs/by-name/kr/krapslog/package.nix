{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libiconv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "krapslog";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "acj";
    repo = "krapslog-rs";
    rev = finalAttrs.version;
    sha256 = "sha256-c/Zh4fOsSKY0XopaklRbFEh4QM5jjUcj0zhAx5v9amI=";
  };

  cargoHash = "sha256-cXK7YZ9i/eKXTHPYnJcvcKyzFlZDnqmCBrEa75Mxfqc=";

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;

  meta = {
    description = "Visualize a log file with sparklines";
    homepage = "https://github.com/acj/krapslog-rs";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ yanganto ];
    mainProgram = "krapslog";
  };
})
