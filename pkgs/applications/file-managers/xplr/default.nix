{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.21.3";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lqFhLCOLiuSQWhbcZUEj2xFRlZ+x1ZTVc8IJw7tJjhE=";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  cargoHash = "sha256-3hrpg2cMvIuFy6mH1/1igIpU4nbzFQLCAhiIRZbTuaI=";

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
