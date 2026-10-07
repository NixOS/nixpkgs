{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pkg-config,
  glib,
}:

buildPythonPackage (finalAttrs: {
  pname = "bluepy";
  version = "1.3.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-KnHtr+EDVl+5kCVv82JMFlMDaoN9/JDh4yuDn4OXHOw=";
  };

  build-system = [ setuptools ];

  buildInputs = [ glib ];
  nativeBuildInputs = [ pkg-config ];

  # tests try to access hardware
  checkPhase = ''
    $out/bin/blescan --help > /dev/null
    $out/bin/sensortag --help > /dev/null
    $out/bin/thingy52 --help > /dev/null
  '';
  pythonImportsCheck = [ "bluepy" ];

  meta = {
    description = "Python interface to Bluetooth LE on Linux";
    homepage = "https://github.com/IanHarvey/bluepy";
    maintainers = with lib.maintainers; [ georgewhewell ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2;
  };
})
