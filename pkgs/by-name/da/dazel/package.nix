{
  lib,
  python3Packages,
  fetchPypi,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "dazel";
  version = "0.0.43";
  pyproject = true;

  build-system = [
    python3Packages.setuptools
  ];

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-2enQRKg4CAPGHte02io+EfiW9AmuP3Qi41vNQeChg+8=";
  };

  meta = {
    homepage = "https://github.com/nadirizr/dazel";
    description = "Run Google's bazel inside a docker container via a seamless proxy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      malt3
    ];
  };
})
