{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cyclonedds";
  version = "0.10.5";

  src = fetchFromGitHub {
    owner = "eclipse-cyclonedds";
    repo = "cyclonedds";
    rev = finalAttrs.version;
    sha256 = "sha256-MQVUZ7PkxauoPpfxlhhAtsKztMe9tcZOpOzshuz/eb8=";
  };

  patches = [
    ./0001-Use-full-path-in-pkgconfig.patch
  ];

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Eclipse Cyclone DDS project";
    homepage = "https://cyclonedds.io/";
    license = with lib.licenses; [ epl20 ];
    maintainers = with lib.maintainers; [ bachp ];
  };
})
