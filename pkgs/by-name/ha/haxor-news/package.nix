{
  lib,
  fetchFromGitHub,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "haxor-news";
  version = "unstable-2022-04-22";
  format = "setuptools";

  # haven't done a stable release in 3+ years, but actively developed
  src = fetchFromGitHub {
    owner = "donnemartin";
    repo = "haxor-news";
    rev = "8294e4498858f036a344b06e82f08b834c2a8270";
    hash = "sha256-0eVk5zj7F3QDFvV0Kv9aeV1oeKxr/Kza6M3pK6hyYuY=";
  };

  propagatedBuildInputs = with python3Packages; [
    click
    colorama
    requests
    pygments
    prompt-toolkit
    six
  ];

  # will fail without pre-seeded config files
  doCheck = false;

  nativeCheckInputs = with python3Packages; [
    unittestCheckHook
    mock
  ];

  unittestFlagsArray = [
    "-s"
    "tests"
    "-v"
  ];

  meta = with lib; {
    homepage = "https://github.com/donnemartin/haxor-news";
    description = "Browse Hacker News like a haxor";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthiasbeyer ];
  };

}
