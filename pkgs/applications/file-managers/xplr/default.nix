{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WUv0F7etmJFNRnHXkQ5G3p/5BWL30kfSYnxXYpAdo+I=";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  cargoSha256 = "sha256-0JJpGSOwayPB3cn7OpBjsOiK4WQNbil3gYrfkqG2cS8=";

  checkFlags = [
    # failure: path::tests::test_relative_to_parent
    "--skip=path::tests::test_relative_to_parent"
  ];

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://xplr.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 thehedgeh0g mimame ];
  };
}
