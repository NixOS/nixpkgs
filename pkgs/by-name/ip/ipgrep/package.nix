{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "ipgrep";
  version = "1.0.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "ipgrep";
    rev = version;
    hash = "sha256-NrhcUFQM+L66KaDRRpAoC+z5s54a+1fqEepTRXVZ5Qs=";
  };

  patchPhase = ''
    mkdir -p ipgrep
    substituteInPlace setup.py \
      --replace-fail "'scripts': []" "'scripts': { 'ipgrep.py' }"
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    pycares
    urllib3
    requests
  ];

  meta = with lib; {
    description = "Extract, defang, resolve names and IPs from text";
    mainProgram = "ipgrep.py";
    longDescription = ''
      ipgrep extracts possibly obfuscated host names and IP addresses
      from text, resolves host names, and prints them, sorted by ASN.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.all;
  };
}
