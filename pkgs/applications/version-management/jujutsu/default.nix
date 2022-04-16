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
, testVersion
, jujutsu
}:

rustPlatform.buildRustPackage rec {
  pname = "jujutsu";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "martinvonz";
    repo = "jj";
    rev = "v${version}";
    sha256 = "sha256-BOT2pKcOSOha28fba62X+GgILcplhkMWhZo7Q0gGTQ8=";
  };

  cargoSha256 = "sha256-uvR+WXX2iIWFhcPYpOoOS1WBvOXuhTmgVVT2446c6XE=";

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
    version = testVersion {
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
