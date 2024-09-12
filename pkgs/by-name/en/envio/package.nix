{ lib
, stdenv
, fetchFromGitHub
, darwin
, gpgme
, libgpg-error
, pkg-config
, rustPlatform
}:

let
  inherit (darwin.apple_sdk.frameworks) Security;
in
rustPlatform.buildRustPackage rec {
  pname = "envio";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "envio-cli";
    repo = "envio";
    rev = "v${version}";
    hash = "sha256-KhjHd+1IeKdASeYP2rPtyTmtkPcBbaruylmOwTPtFgo=";
  };

  cargoHash = "sha256-qmJUARwsGln07RAX1Ab0cNDgJq7NkezuT0tZsyd48Mw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libgpg-error gpgme ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  # Remove postPatch when updating to the next envio release
  # For details see https://github.com/envio-cli/envio/pull/31
  postPatch = ''
    substituteInPlace build.rs\
      --replace 'fn get_version() -> String {' 'fn get_version() -> String { return "${version}".to_string();'
  '';

  meta = with lib; {
    homepage    = "https://envio-cli.github.io/home";
    changelog   = "https://github.com/envio-cli/envio/blob/${version}/CHANGELOG.md";
    description = "Modern and secure CLI tool for managing environment variables";
    mainProgram = "envio";
    longDescription = ''
      Envio is a command-line tool that simplifies the management of
      environment variables across multiple profiles. It allows users to easily
      switch between different configurations and apply them to their current
      environment.
    '';
    license     = with licenses; [ mit asl20 ];
    platforms   = platforms.unix;
    maintainers = with maintainers; [ afh ];
  };
}
