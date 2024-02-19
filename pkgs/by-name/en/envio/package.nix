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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "envio-cli";
    repo = "envio";
    rev = "v${version}";
    hash = "sha256-HVu2Ua1iu7Z14RUbdDQ4ElOGnfYjZCekFvAolu2lM7w=";
  };

  cargoHash = "sha256-AVbAHaLARMKGf5ZIygyWWSkg4U1Xkfjwm9XPNZNtUsE=";

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
