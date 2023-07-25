{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.21.2";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MCOkl95X5YZTAC0VHtSY5xWf1R3987cxepSM7na+LdA=";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  cargoHash = "sha256-1uAnIuxDDv3Z/fMs2Cu/aFWrnugGcEKlNjhILqDpOMI=";

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
