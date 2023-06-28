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
  version = "0.4.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-8v10Oe3J0S9xp4b2UDOnv+W0UDgveK+mAyV3I/zZUGw=";
  };

  cargoHash = "sha256-MdHk8i/murKcWi9gydyPyq/6r1SovKP04PMJyXXrCiQ=";

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
