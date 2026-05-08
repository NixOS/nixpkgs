{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication {
  pname = "secretfinder";
  version = "0-unstable-2024-05-26";
  pyproject = false;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "m4ll0k";
    repo = "SecretFinder";
    rev = "d06119dedd9c1505137d1ec4792d5d5b65c7425d";
    hash = "sha256-PXmW8t7g6JC12R/xDTi6MN5R2XM3b2zzHH6GVeZfBxk=";
  };

  propagatedBuildInputs = with python3Packages; [
    requests
    jsbeautifier
    lxml
    requests-file
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 SecretFinder.py $out/bin/secretfinder
    runHook postInstall
  '';

  doCheck = false;

  meta = {
    description = "Discover sensitive data in JavaScript files";
    homepage = "https://github.com/m4ll0k/SecretFinder";
    license = lib.licenses.gpl3Only;
    mainProgram = "secretfinder";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
