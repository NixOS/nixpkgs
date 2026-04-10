{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmsym";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "mcodev31";
    repo = "libmsym";
    tag = "v${finalAttrs.version}";
    sha256 = "k+OEwrA/saupP/wX6Ii5My0vffiJ0X9xMCTrliMSMik=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" ];

  meta = {
    description = "Molecular point group symmetry lib";
    homepage = "https://github.com/mcodev31/libmsym";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sheepforce ];
  };
})
