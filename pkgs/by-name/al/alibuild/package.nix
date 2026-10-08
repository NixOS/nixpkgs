{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "alibuild";
  version = "1.17.44";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-hLFbxJVOWp1j8pV2v3h7UBZ691EONGb5HNIDrizyq6E=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    requests
    pyyaml
    boto3
    jinja2
    distro
  ];

  postPatch = ''
    # strip setuptools_scm upper bound limit
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools_scm[toml]>=6.2,<10" "setuptools_scm[toml]>=6.2"
    substituteInPlace setup.py \
      --replace-fail "setuptools_scm>=6.2,<10" "setuptools_scm>=6.2"
  '';

  meta = {
    homepage = "https://alisw.github.io/alibuild/";
    description = "Build tool for ALICE experiment software";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ktf ];
  };
})
