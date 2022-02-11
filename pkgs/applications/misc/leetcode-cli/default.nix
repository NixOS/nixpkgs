{ lib
, fetchCrate
, rustPlatform
, pkg-config
, openssl
, dbus
, sqlite
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "leetcode-cli";
  version = "0.3.10";

  src = fetchCrate {
    inherit pname version;
    sha256 = "SkJLA49AXNTpiWZByII2saYLyN3bAAJTlCvhamlOEXA=";
  };

  cargoSha256 = "xhKF4qYOTdt8iCSPY5yT8tH3l54HdkOAIS2SBGzqsdo=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    dbus
    sqlite
  ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = "May the code be with you 👻";
    longDescription = "Use leetcode.com in command line";
    homepage = "https://github.com/clearloop/leetcode-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ congee ];
    mainProgram = "leetcode";
  };
}
