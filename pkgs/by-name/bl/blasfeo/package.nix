{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
  withTarget ? "GENERIC",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blasfeo";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "giaf";
    repo = "blasfeo";
    rev = finalAttrs.version;
    hash = "sha256-Qm6N1PeWZtS9H5ZuL31NbsctpZiJaGI7bfSPMUmI2BQ=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DTARGET=${withTarget}" ];

  meta = {
    description = "Basic linear algebra subroutines for embedded optimization";
    homepage = "https://github.com/giaf/blasfeo";
    changelog = "https://github.com/giaf/blasfeo/blob/${finalAttrs.version}/Changelog.txt";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
