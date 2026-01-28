{
  lib,
  fetchFromGitHub,
  rustPlatform,
  R,
}:

rustPlatform.buildRustPackage rec {
  pname = "ark";
  version = "0.1.222";

  src = fetchFromGitHub {
    owner = "posit-dev";
    repo = "ark";
    tag = version;
    hash = "sha256-68pQyZvZageyIEbUfYpIkWuxHclc73NpN6/QKsNCXHA=";
  };

  cargoHash = "sha256-MotCHl3FEF6D5gNHhayatnAPkbbWTN7ajwF8PY3KWgs=";

  buildAndTestSubdir = "crates/ark";

  nativeBuildInputs = [ R ];

  useNextest = true;

  checkFlags = [
    # Failed Japanese characters truncation https://github.com/posit-dev/ark/issues/982
    "--skip data_explorer::format::tests::test_truncation"
    # Required R 'Matrix' package, could not set R_LIBS_SITE in nextest
    "--skip variables::variable::tests::test_s4_with_different_length"
  ];

  meta = {
    description = "R kernel for Jupyter applications";
    homepage = "https://github.com/posit-dev/ark";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Th1nkK1D ];
  };
}
