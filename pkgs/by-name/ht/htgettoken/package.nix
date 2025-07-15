{
  lib,
  fetchFromGitHub,
  python3,
  makeWrapper,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "htgettoken";
  version = "2.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "fermitools";
    repo = "htgettoken";
    tag = "v${version}";
    hash = "sha256-3xBACXxH5G1MO2dNFFSL1Rssc8RdauvLZ4Tx2djOgyw=";
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
