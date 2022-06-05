{ buildPythonApplication
, attrs
, click
, cloudflare
, fetchFromGitHub
, lib
, poetry
, pydantic
, pytestCheckHook
, requests
}:

buildPythonApplication rec {
  pname = "cloudflare-dyndns";
  version = "4.1";

  src = fetchFromGitHub {
    owner = "kissgyorgy";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6Q5fpJ+HuQ+hc3xTtB5tR43pn9WZ0nZZR723iLAkpis=";
  };

  format = "pyproject";

  nativeBuildInputs = [ poetry ];

  propagatedBuildInputs = [
    attrs
    click
    cloudflare
    pydantic
    requests
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'click = "^7.0"' 'click = "*"'
  '';

  checkInputs = [ pytestCheckHook ];

  disabledTests = [
    "test_get_ipv4"
  ];

  meta = with lib; {
    description = " CloudFlare Dynamic DNS client ";
    homepage = "https://github.com/kissgyorgy/cloudflare-dyndns";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
