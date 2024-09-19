{
  lib,
  fetchFromGitHub,
  python3,
  makeWrapper,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "htgettoken";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "fermitools";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-yHUD8UaRNclALKKToFNzC49w5jivabXBt28xi6/u0Ow=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    makeWrapper
  ];

  postInstall = with python3.pkgs; ''
    wrapProgram $out/bin/htgettoken \
      --set PYTHONPATH "${
        makePythonPath [
          gssapi
          paramiko
          urllib3
        ]
      }"
  '';

  meta = with lib; {
    description = "Gets OIDC authentication tokens for High Throughput Computing via a Hashicorp vault server ";
    license = licenses.bsd3;
    homepage = "https://github.com/fermitools/htgettoken";
    maintainers = with maintainers; [ veprbl ];
  };
}
