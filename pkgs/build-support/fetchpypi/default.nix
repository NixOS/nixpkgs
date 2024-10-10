# `fetchPypi` function for fetching artifacts from PyPI.
{
  fetchurl,
  makeOverridable,
  jq,
  cacert,
}:
let
  computeUrl = {format ? "setuptools", ... } @attrs: let
    computeWheelUrl = {pname, version, dist ? "py2.py3", python ? "py2.py3", abi ? "none", platform ? "any"}:
    # Fetch a wheel. By default we fetch an universal wheel.
    # See https://www.python.org/dev/peps/pep-0427/#file-name-convention for details regarding the optional arguments.
      "https://files.pythonhosted.org/packages/${dist}/${builtins.substring 0 1 pname}/${pname}/${pname}-${version}-${python}-${abi}-${platform}.whl";

    computeSourceUrl = {pname, version, extension ? "tar.gz"}:
    # Fetch a source tarball.
      "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${pname}-${version}.${extension}";

    compute = (if format == "wheel" then computeWheelUrl
      else if format == "setuptools" then computeSourceUrl
      else throw "Unsupported format ${format}");


  in compute (builtins.removeAttrs attrs ["format"]);
in
makeOverridable (
  {
    format ? "setuptools",
    sha256 ? "",
    hash ? "",
    pname,
    version,
    checkTls ? false,
    ...
  }@attrs:
  let
    url = computeUrl (builtins.removeAttrs attrs ["sha256" "hash" "checkTls"]);
    packagetype = if format == "wheel" then "wheel" else "sdist";
  in
  (fetchurl {
    inherit
      sha256
      hash;
      name = baseNameOf url;

      urlScript =
      ''
curl=(
    curl
    --location
    --max-redirs 20
    --retry 3
    --disable-epsv
    --cookie-jar cookies
    --user-agent "curl/$curlVersion Nixpkgs/$nixpkgsVersion"
)

${if checkTls then "SSL_CERT_FILE = ${cacert}/etc/ssl/certs/ca-bundle.crt" else "/no-cert-file.crt"}

if ! [ -f "$SSL_CERT_FILE" ]; then
    curl+=(--insecure)
fi

$\{curl[@]\} https://pypi.org/pypi/${pname}/json  | ${jq}/bin/jq -r '.releases."${version}".[] | select(.packagetype == "${packagetype}") .url'
'';
  })
)
