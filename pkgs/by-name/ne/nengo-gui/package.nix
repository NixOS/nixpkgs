{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "nengo-gui";
  version = "0.4.9";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "nengo";
    repo = "nengo-gui";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-aBi4roe9pqPmpbW5zrbDoIvyH5mTKgIzL2O5j1+VBMY=";
  };

  propagatedBuildInputs = with python3Packages; [ nengo ];

  # checks req missing:
  #   pyimgur
  doCheck = false;

  meta = {
    description = "Nengo interactive visualizer";
    homepage = "https://nengo.ai/";
    license = lib.licenses.unfreeRedistributable;
    maintainers = [ ];
  };
})
