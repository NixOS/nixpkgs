{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
  withTarget ? "GENERIC",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blasfeo";
  version = "0.1.4.1";

  src = fetchFromGitHub {
    owner = "giaf";
    repo = "blasfeo";
    rev = finalAttrs.version;
    hash = "sha256-peopXTJejgqS/DL4h52h1vVJe6jjWPQb6x/9SPvFl6k=";
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
