{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cyclonedds";
  version = "11.0.1";

  src = fetchFromGitHub {
    owner = "eclipse-cyclonedds";
    repo = "cyclonedds";
    rev = finalAttrs.version;
    sha256 = "sha256-+p1J6xEwrUPLheuQL4gm4x1e6rH/+qYsWc9eeJrmRR4=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Eclipse Cyclone DDS project";
    homepage = "https://cyclonedds.io/";
    license = with lib.licenses; [ epl20 ];
    maintainers = with lib.maintainers; [ bachp ];
  };
})
