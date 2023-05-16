{ lib
, fetchCrate
, rustPlatform
, pkg-config
, openssl
, dbus
, sqlite
, stdenv
, darwin
<<<<<<< HEAD
, testers
, leetcode-cli
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "leetcode-cli";
<<<<<<< HEAD
  version = "0.4.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-Yr8Jsy8863O6saaFRAxssni+PtK7XYe+Iifgxu8Rx6Q=";
  };

  cargoHash = "sha256-rab/oLr27UOlnwUUB1RXC/egLoYyzmVtzN1L+AGed8o=";
=======
  version = "0.3.11";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-DHtIhiRPRGuO6Rf1d9f8r0bMOHqAaJleUvYNyPiX6mc=";
  };

  cargoSha256 = "sha256-Suk/nQ+JcoD9HO9x1lYp+p4qx0DZ9dt0p5jPz0ZQB+k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    dbus
    sqlite
  ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

<<<<<<< HEAD
  passthru.tests = testers.testVersion {
    package = leetcode-cli;
    command = "leetcode -V";
    version = "leetcode ${version}";
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "May the code be with you 👻";
    longDescription = "Use leetcode.com in command line";
    homepage = "https://github.com/clearloop/leetcode-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ congee ];
    mainProgram = "leetcode";
  };
}
