{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cloudhunter";
  version = "0.7.1";
  format = "other";

  src = fetchFromGitHub {
    owner = "belane";
    repo = "CloudHunter";
    rev = "refs/tags/v${version}";
    hash = "sha256-7iT4vr0kcNXEyJJdBbJsllIcbZRGY3T5t/FjEONkuq0=";
  };

  postPatch = ''
    substituteInPlace cloudhunter.py \
      --replace "'permutations.txt'" "'$out/share/permutations.txt'" \
      --replace "'resolvers.txt'" "'$out/share/resolvers.txt'"
  '';

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    dnspython
    requests
    tldextract
    urllib3
    xmltodict
  ];

  installPhase = ''
    runHook preInstall
    install -vD cloudhunter.py $out/bin/cloudhunter
    install -vD  permutations-big.txt permutations.txt resolvers.txt -t $out/share
    install -vd $out/${python3.sitePackages}/
    runHook postInstall
  '';

  # Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "Cloud bucket scanner";
    mainProgram = "cloudhunter";
    homepage = "https://github.com/belane/CloudHunter";
    changelog = "https://github.com/belane/CloudHunter/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
