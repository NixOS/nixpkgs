{
  lib,
  fetchFromGitHub,
  rustPlatform,
  R,
}:

rustPlatform.buildRustPackage rec {
  pname = "ark";
  version = "0.1.220";

  src = fetchFromGitHub {
    owner = "posit-dev";
    repo = "ark";
    tag = version;
    hash = "sha256-7COwQzVT7SvnjKNx7Fg8wufIWkY5cbY5V3R/zsnXufA=";
  };

  cargoHash = "sha256-/LhXQ3D+NrzH3C9+8OuSVyeRAlvQzCBzfg3hubgo58U=";

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
