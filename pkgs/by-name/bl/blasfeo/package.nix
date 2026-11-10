{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
  withTarget ? "GENERIC",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blasfeo";
  version = "0.1.4.3";

  src = fetchFromGitHub {
    owner = "giaf";
    repo = "blasfeo";
    tag = finalAttrs.version;
    hash = "sha256-+hdS/HGw49pSKOOL4jzAhScVGIFTsEqYwXSpQi3GBm0=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DTARGET=${withTarget}" ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Basic linear algebra subroutines for embedded optimization";
    homepage = "https://github.com/giaf/blasfeo";
    changelog = "https://github.com/giaf/blasfeo/blob/${finalAttrs.version}/Changelog.txt";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
