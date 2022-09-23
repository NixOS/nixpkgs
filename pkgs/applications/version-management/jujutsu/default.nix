{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, dbus
, sqlite
, Security
, SystemConfiguration
, libiconv
, testers
, jujutsu
}:

rustPlatform.buildRustPackage rec {
  pname = "jujutsu";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "martinvonz";
    repo = "jj";
    rev = "v${version}";
    sha256 = "sha256-G8Y8ooi3aX6v/Ied62eSfo6PvXbZtx455bF0wVkZN30=";
  };

  cargoSha256 = "sha256-7nWrwpv3xAffKiaUsnoA+h6ledjgG9tQeQ69WNl6e8o=";

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    dbus
    sqlite
  ] ++ lib.optionals stdenv.isDarwin [
    Security
    SystemConfiguration
    libiconv
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = jujutsu;
      command = "jj --version";
    };
  };

  meta = with lib; {
    description = "A Git-compatible DVCS that is both simple and powerful";
    homepage = "https://github.com/martinvonz/jj";
    changelog = "https://github.com/martinvonz/jj/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ _0x4A6F ];
    mainProgram = "jj";
  };
}
