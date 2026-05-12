{
  fetchFromGitHub,
  lib,
  python3Packages,
  ...
}:

python3Packages.buildPythonPackage rec {
  pname = "opencart-mcp";
  version = "0.4.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "chrisbray85";
    repo = "opencart-mcp";
    tag = "v${version}";
    sha256 = "sha256-6ur+jla1w8a9T5Y64tld77c6PWK/s21mVkmNkFDCWnw=";
  };

  format = "pyproject";
  nativeBuildInputs = [ python3Packages.setuptools ];

  propagatedBuildInputs = with python3Packages; [
    fastmcp
    paramiko
    python-dotenv
  ];

  meta = {
    description = "MCP server for OpenCart.";
    homepage = "https://github.com/chrisbray85/opencart-mcp";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.icedborn ];
  };
}
