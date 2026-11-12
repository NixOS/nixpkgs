{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cyclonedds,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cyclonedds-cxx";
  version = "11.1.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "eclipse-cyclonedds";
    repo = "cyclonedds-cxx";
    tag = finalAttrs.version;
    hash = "sha256-sTplnqRxVvui2YHcTMRjsbvKUxlPezyddS6AQWRbQi0=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ cyclonedds ];

  meta = {
    description = "C++ binding for Eclipse Cyclone DDS";
    homepage = "https://cyclonedds.io/";
    license = with lib.licenses; [
      epl20
      asl20
    ];
    maintainers = with lib.maintainers; [ linbreux ];
  };
})
