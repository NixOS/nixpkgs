{
  fetchFromGitHub,
  lib,
  bash,
  lemurs,
  linux-pam,
  rustPlatform,
  systemdMinimal,
  testers,
}:
rustPlatform.buildRustPackage {
  pname = "lemurs";
  version = "0.3.2-unstable-2024-07-24";

  src = fetchFromGitHub {
    owner = "coastalwhite";
    repo = "lemurs";
    rev = "1d4be7d0c3f528a0c1e9326ac77f1e8a17161c83";
    hash = "sha256-t/riJpgy0bD5CU8Zkzket4Gks2JXXSLRreMlrxlok0c=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Cwgu30rGe1/Mm4FEEH11OTtTHUlBNwl5jVzmJg5qQe8=";

  buildInputs = [
    bash
    linux-pam
    systemdMinimal
  ];

  passthru.tests.version = testers.testVersion {
    package = lemurs;
    # Package version is now different from the version that lemurs reports itself as.
    version = "0.3.2";
  };

  meta = {
    description = "Customizable TUI display/login manager written in Rust";
    homepage = "https://github.com/coastalwhite/lemurs";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      jeremiahs
      nullcube
    ];
    mainProgram = "lemurs";
  };
}
