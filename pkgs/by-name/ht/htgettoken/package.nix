{
  lib,
  fetchFromGitHub,
  python3,
  makeWrapper,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "htgettoken";
<<<<<<< HEAD
  version = "2.5";
=======
  version = "2.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "fermitools";
    repo = "htgettoken";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-CUzkivrkvMr8EE00tjHswyK5WidQjmki5nLYpeb8jjU=";
=======
    hash = "sha256-3xBACXxH5G1MO2dNFFSL1Rssc8RdauvLZ4Tx2djOgyw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Gets OIDC authentication tokens for High Throughput Computing via a Hashicorp vault server ";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/fermitools/htgettoken";
    maintainers = with lib.maintainers; [ veprbl ];
=======
  meta = with lib; {
    description = "Gets OIDC authentication tokens for High Throughput Computing via a Hashicorp vault server ";
    license = licenses.bsd3;
    homepage = "https://github.com/fermitools/htgettoken";
    maintainers = with maintainers; [ veprbl ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
