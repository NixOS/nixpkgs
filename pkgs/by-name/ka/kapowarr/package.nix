{
  lib,
  python3,
  python3Packages,
  fetchFromGitHub,
  makeWrapper,
}:

python3Packages.buildPythonApplication rec {
  pname = "kapowarr";
  version = "1.2.0-unstable-2026-01-04";
  format = "other";

  src = fetchFromGitHub {
    owner = "Casvt";
    repo = "Kapowarr";
    rev = "ad0c8f915d451d662a1577a3a9ad3047d6ec6094";
    hash = "sha256-eZZ8dkza+QqulybtuZithJgRAPoyEuU9cWcUOnaA7/0=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  propagatedBuildInputs = with python3Packages; [
    typing-extensions
    requests
    beautifulsoup4
    flask
    waitress
    cryptography
    bencoding
    aiohttp
    flask-socketio
    websocket-client
  ];

  # Since there's no setup.py, we need to manually install the package
  installPhase = ''
    runHook preInstall

    # Install the package structure
    mkdir -p $out/${python3.sitePackages}
    cp -r backend $out/${python3.sitePackages}/
    cp -r frontend $out/${python3.sitePackages}/

    # the program checks its own pyproject.toml when running
    # so make sure there is a copy it can find
    cp pyproject.toml $out/${python3.sitePackages}

    # Install the main script
    mkdir -p $out/bin
    cp ${src}/Kapowarr.py $out/bin/kapowarr
    chmod +x $out/bin/kapowarr

    # Make sure the script can find the modules
    wrapProgram $out/bin/kapowarr \
      --set PYTHONPATH "$out/${python3.sitePackages}:$PYTHONPATH"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Kapowarr is a software to build and manage a comic book library, fitting in the *arr suite of software.";
    homepage = "https://casvt.github.io/Kapowarr/";
    license = licenses.gpl3Only;
    maintainers = [
      maintainers.JollyDevelopment
    ];
    platforms = platforms.all;
  };
}
