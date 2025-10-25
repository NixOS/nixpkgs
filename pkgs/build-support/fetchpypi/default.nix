# `fetchPypi` function for fetching artifacts from PyPI.
{
  fetchurl,
  makeOverridable,
}:

let
  computeUrl =
    {
      format ? "setuptools",
      ...
    }@attrs:
    let
      computeWheelUrl =
        {
          pname,
          version,
          dist ? "py2.py3",
          python ? "py2.py3",
          abi ? "none",
          platform ? "any",
        }:
        # Fetch a wheel. By default we fetch an universal wheel.
        # See https://www.python.org/dev/peps/pep-0427/#file-name-convention for details regarding the optional arguments.
        "https://files.pythonhosted.org/packages/${dist}/${builtins.substring 0 1 pname}/${pname}/${pname}-${version}-${python}-${abi}-${platform}.whl";

      computeSourceUrl =
        {
          pname,
          version,
          extension ? "tar.gz",
        }:
        # Fetch a source tarball.
        "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${pname}-${version}.${extension}";

      compute = (
        if format == "wheel" then
          computeWheelUrl
        else if format == "setuptools" then
          computeSourceUrl
        else
          throw "Unsupported format ${format}"
      );

    in
    compute (removeAttrs attrs [ "format" ]);

in
makeOverridable (
  {
    format ? "setuptools",
    sha256 ? "",
    hash ? "",
    pname,
    version,
    ...
  }@attrs:
  let
    url = computeUrl (
      removeAttrs attrs [
        "sha256"
        "hash"
      ]
    );
    meta = {
      identifiers.purlParts = {
        type = "pypi";
        # https://github.com/package-url/purl-spec/blob/18fd3e395dda53c00bc8b11fe481666dc7b3807a/types-doc/pypi-definition.md
        spec = "${pname}@${version}";
      };
    };
  in
  fetchurl {
    inherit
      url
      sha256
      hash
      meta
      ;
  }
)
