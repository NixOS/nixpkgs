{ lib
, fetchFromGitHub
, openjdk
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "html5validator";
  version = "0.4.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "svenkreiss";
    repo = "html5validator";
    rev = "refs/tags/v${version}";
    hash = "sha256-yvclqE4+2R9q/UJU9W95U1/xVJeNj+5eKvT6VQel9k8=";
  };

  propagatedBuildInputs = [
    openjdk
  ] ++ (with python3.pkgs; [
    pyyaml
  ]);

  nativeCheckInputs = with python3.pkgs; [
    hacking
    pytestCheckHook
  ];

  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  meta = with lib; {
    description = "Command line tool that tests files for HTML5 validity";
    mainProgram = "html5validator";
    homepage = "https://github.com/svenkreiss/html5validator";
    changelog = "https://github.com/svenkreiss/html5validator/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ phunehehe ];
  };
}
