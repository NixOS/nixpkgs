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
  version = "unstable-2022-02-21";

  src = fetchFromGitHub {
    owner = "martinvonz";
    repo = "jj";
    rev = "f9298582a78a4d06e6b9c5b51c67e034e7406739";
    sha256 = "sha256-BQldf1AQr91cvfvlajjfzXt8BVToKV7eq5k11MiX9QY=";
  };

  cargoSha256 = "sha256-VWI3GQImPMy5a/c3QkDNXONoXvuuI2ofAmdZaiWSFvc=";

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
      # Remove version on release builds
      version = "0.2.0";
    };
  };

  meta = with lib; {
    description = "A Git-compatible DVCS that is both simple and powerful";
    homepage = "https://github.com/martinvonz/jj";
    license = licenses.asl20;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
