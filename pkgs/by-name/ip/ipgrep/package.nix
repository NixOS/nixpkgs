{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ipgrep";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "ipgrep";
    rev = finalAttrs.version;
    hash = "sha256-4Fa0fqd8S6yZmUzHlgkUWgYZhAbf48zZhzq4Fx3MS5A=";
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

  meta = {
    description = "Extract, defang, resolve names and IPs from text";
    mainProgram = "ipgrep.py";
    longDescription = ''
      ipgrep extracts possibly obfuscated host names and IP addresses
      from text, resolves host names, and prints them, sorted by ASN.
    '';
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
