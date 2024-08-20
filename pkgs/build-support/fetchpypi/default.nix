# `fetchPypi` function for fetching artifacts from PyPI.
{
  fetchurl,
  makeOverridable,
  lib,
}:

let
  computeUrl =
    {
      format ? "setuptools",
      customPath ? null,
      pname,
      version,
      dist ? "py2.py3",
      python ? "py2.py3",
      abi ? "none",
      platform ? "any",
      extension ? "tar.gz",
    }:
    let
      computeWheelUrl =
        {
          pname,
          version,
          python,
          abi,
          platform,
          customPath,
        }:
        let
          # Use customPath if provided, otherwise default to pname-based path
          pathPart = if customPath != null then customPath else "${builtins.substring 0 1 pname}/${pname}";
        in
        # Fetch a wheel. By default, we fetch a universal wheel.
        # See https://www.python.org/dev/peps/pep-0427/#file-name-convention for details regarding the optional arguments.
        "https://files.pythonhosted.org/packages/${pathPart}/${pname}-${version}-${python}-${abi}-${platform}.whl";

      computeSourceUrl =
        {
          pname,
          version,
          extension,
        }:
        # Fetch a source tarball.
        "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${pname}-${version}.${extension}";
    in
    if format == "wheel" then
      computeWheelUrl {
        inherit
          pname
          version
          python
          abi
          platform
          customPath
          ;
      }
    else if format == "setuptools" then
      computeSourceUrl { inherit pname version extension; }
    else
      throw "Unsupported format ${format}";
in
makeOverridable (
  {
    format ? "setuptools",
    sha256 ? "",
    hash ? "",
    ...
  }@attrs:
  let
    url = computeUrl (
      builtins.removeAttrs attrs [
        "sha256"
        "hash"
      ]
    );
  in
  fetchurl { inherit url sha256 hash; }
)
