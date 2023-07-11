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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "martinvonz";
    repo = "jj";
    rev = "v${version}";
    sha256 = "sha256-FczlSBlLhLIamLiY4cGVAoHx0/sxx+tykICzedFbbx8=";
  };

  cargoHash = "sha256-PydDgXp47KUSLvAQgfO+09lrzTnBjzGd+zA5f/jZfRc=";

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
