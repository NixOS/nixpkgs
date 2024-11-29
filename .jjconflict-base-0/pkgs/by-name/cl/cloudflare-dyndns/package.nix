{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cloudflare-dyndns";
  version = "5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kissgyorgy";
    repo = "cloudflare-dyndns";
    rev = "v${version}";
    hash = "sha256-tI6qdNxIMEuAR+BcqsRi2EBXTQnfdDLKW7Y+fbcmlao=";
  };

  build-system = with python3.pkgs; [
    poetry-core
  ];

  dependencies = with python3.pkgs; [
    attrs
    click
    cloudflare
    pydantic
    requests
    httpx
    truststore
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  disabledTests = [
    "test_get_ipv4"
  ];

  meta = with lib; {
    description = "CloudFlare Dynamic DNS client";
    homepage = "https://github.com/kissgyorgy/cloudflare-dyndns";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
    mainProgram = "cloudflare-dyndns";
  };
}
