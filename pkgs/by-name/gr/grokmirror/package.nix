{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "grokmirror";
  version = "2.0.12";
  format = "setuptools";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mricon";
    repo = "grokmirror";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4UwVcE5IYUmAkgbLTFg5Rw5yZUZWkok3iw7LO8pplV4=";
  };

  propagatedBuildInputs = with python3Packages; [
    packaging
    requests
  ];

  meta = {
    homepage = "https://github.com/mricon/grokmirror";
    description = "Framework to smartly mirror git repositories";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ maxmosk ];
  };
})
