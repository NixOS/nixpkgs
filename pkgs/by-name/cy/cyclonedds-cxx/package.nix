{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cyclonedds,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cyclonedds-cxx";
  version = "11.0.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "eclipse-cyclonedds";
    repo = "cyclonedds-cxx";
    tag = finalAttrs.version;
    hash = "sha256-O6jNvq8NcwLxL7zIDeNdh10XUJ9FjHb3HYfCCa38cyA=";
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
