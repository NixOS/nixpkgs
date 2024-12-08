{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication {
  pname = "altdns";
  version = "1.0.2-unstable-2021-09-09";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "infosec-au";
    repo = "altdns";
    rev = "8c1de0fa8365153832bb58d74475caa15d2d077a";
    hash = "sha256-ElY6AZ7IBnOh7sRWNSQNmq7AYGlnjvYRn8/U+29BwWA=";
  };

  prePatch = ''
    substituteInPlace requirements.txt \
      --replace-fail "argparse" ""
    substituteInPlace setup.py \
      --replace-fail "argparse" ""
  '';

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    dnspython
    termcolor
    tldextract
  ];

  postInstall = ''
    cp $src/words.txt $out/
  '';

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "altdns"
  ];

  meta = with lib; {
    description = "Generates permutations, alterations and mutations of subdomains and then resolves them";
    homepage = "https://github.com/infosec-au/altdns";
    license = licenses.asl20;
    maintainers = with maintainers; [ octodi ];
    mainProgram = "altdns";
  };
}
