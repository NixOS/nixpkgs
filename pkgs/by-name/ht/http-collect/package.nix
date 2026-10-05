{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "http-collect";
  version = "1.0.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "equwal";
    repo = "sh";
    tag = "v${version}";
    hash = "sha256-7ZkH7xSTaEuPdtP/LI5vHKCfovVilEEohgIOnzFntCk=";
  };

  dependencies = with python3Packages; [
    flask
    qrcode
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 http-collect -t $out/bin
    runHook postInstall
  '';

  meta = {
    description = "Serve a secret URL and QR code where a phone uploads files and text";
    homepage = "https://github.com/equwal/sh";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "http-collect";
    platforms = lib.platforms.unix;
  };
}
