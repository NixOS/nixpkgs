{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "npf-renderer";
  version = "0.13.0";
  format = "pyproject";

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "npf_renderer";
    inherit (finalAttrs) version;
    hash = "sha256-u75HfEeNAlhCTwgJb3De1FPXKriNCn9UwkeIqBDBwgQ=";
  };

  nativeBuildInputs = [
    python3Packages.setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    dominate
    intervaltree
    orjson
  ];

  pythonImportsCheck = [ "npf_renderer" ];

  meta = {
    description = "Renderer for Tumblr Neue Post Format";
    longDescription = ''
      Python library and renderer for Tumblr's Neue Post Format (NPF),
      used to transform complex post structures into clean HTML.
    '';
    homepage = "https://github.com/syeopite/npf-renderer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
