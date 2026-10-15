{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "colorz";
  version = "1.0.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "0ghd90lgplf051fs5n5bb42zffd3fqpgzkbv6bhjw7r8jqwgcky0";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    pillow
    scipy
  ];

  checkPhase = ''
    $out/bin/colorz --help > /dev/null
  '';

  meta = {
    description = "Color scheme generator";
    homepage = "https://github.com/metakirby5/colorz";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ skykanin ];
    mainProgram = "colorz";
  };
})
