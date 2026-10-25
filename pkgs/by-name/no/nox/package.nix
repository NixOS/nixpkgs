{
  lib,
  python3Packages,
  fetchurl,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "nox";
  version = "0.0.6";
  pyproject = true;

  src = fetchurl {
    url = "mirror://pypi/n/nix-nox/nix-nox-${finalAttrs.version}.tar.gz";
    sha256 = "1qcbhdnhdhhv7q6cqdgv0q55ic8fk18526zn2yb12x9r1s0lfp9z";
  };

  patches = [
    ./nox-review-wip.patch
    # https://github.com/madjar/nox/pull/100
    ./move-to-attrs.patch
  ];

  build-system = with python3Packages; [
    setuptools
    pbr
  ];

  dependencies = with python3Packages; [
    dogpile-cache
    click
    requests
    attrs
    setuptools # pkg_resources is imported during runtime
  ];

  pythonImportsCheck = [ "nox" ];

  meta = {
    homepage = "https://github.com/madjar/nox";
    description = "Tools to make nix nicer to use";
    maintainers = [ lib.maintainers.madjar ];
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
