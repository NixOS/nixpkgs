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

<<<<<<< HEAD
  meta = {
    description = "CloudFlare Dynamic DNS client";
    homepage = "https://github.com/kissgyorgy/cloudflare-dyndns";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lovesegfault ];
=======
  meta = with lib; {
    description = "CloudFlare Dynamic DNS client";
    homepage = "https://github.com/kissgyorgy/cloudflare-dyndns";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "cloudflare-dyndns";
  };
}
