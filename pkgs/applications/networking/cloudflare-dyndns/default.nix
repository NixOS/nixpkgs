{ lib
, buildPythonApplication
, attrs
, click
, cloudflare
, fetchFromGitHub
, fetchpatch
, poetry-core
, pydantic
, pytestCheckHook
, requests
}:

buildPythonApplication rec {
  pname = "cloudflare-dyndns";
  version = "4.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "kissgyorgy";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6Q5fpJ+HuQ+hc3xTtB5tR43pn9WZ0nZZR723iLAkpis=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    attrs
    click
    cloudflare
    pydantic
    requests
  ];

  checkInputs = [
    pytestCheckHook
  ];

  patches = [
    # Switch to poetry-core, https://github.com/kissgyorgy/cloudflare-dyndns/pull/22
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/kissgyorgy/cloudflare-dyndns/commit/741ed1ccb3373071ce15683a3b8ddc78d64866f8.patch";
      sha256 = "sha256-mjSah0DWptZB6cjhP6dJg10BpJylPSQ2K4TKda7VmHw=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'click = "^7.0"' 'click = "*"' \
      --replace 'attrs = "^21.1.0"' 'attrs = "*"'
  '';

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
