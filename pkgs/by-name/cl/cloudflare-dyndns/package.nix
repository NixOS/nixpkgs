{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cloudflare-dyndns";
  version = "5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kissgyorgy";
    repo = "cloudflare-dyndns";
    rev = "v${version}";
    hash = "sha256-tCZX9CKDwGAZ8/rwI764uuE9SQ1A5WhVoqgUegJ19g4=";
  };

  build-system = with python3.pkgs; [
    hatchling
  ];

  dependencies = with python3.pkgs; [
    click
    httpx
    pydantic
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
