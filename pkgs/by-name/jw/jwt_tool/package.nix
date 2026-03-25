{
  fetchFromGitHub,
  lib,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "jwt_tool";
  version = "2.3.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "ticarpi";
    repo = "jwt_tool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hro7Big55b26BW3hyr8pE7f8vq/ley+M4Yiuk9SJObg=";
  };

  propagatedBuildInputs = with python3Packages; [
    termcolor
    cprint
    pycryptodomex
    requests
    ratelimit
  ];

  installPhase = ''
    runHook preInstall
    install -D jwt_tool.py "$out"/bin/jwt_tool
    runHook postInstall
  '';

  meta = {
    description = "Toolkit for testing, tweaking and cracking JSON Web Tokens";
    mainProgram = "jwt_tool";
    homepage = "https://github.com/ticarpi/jwt_tool";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ stacksparrow4 ];
  };
})
