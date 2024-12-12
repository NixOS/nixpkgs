{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gyb";
  version = "1.82";
  format = "other";

  src = fetchFromGitHub {
    owner = "GAM-team";
    repo = "got-your-back";
    rev = "refs/tags/v${version}";
    hash = "sha256-eKeT2tVBK2DcTOEC6Tvo+igPXPOD1wy66+kr0ltnMIU=";
  };

  dependencies = with python3.pkgs; [
    google-api-python-client
    google-auth
    google-auth-oauthlib
    google-auth-httplib2
    httplib2
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,${python3.sitePackages}}
    mv gyb.py $out/bin/gyb
    mv *.py $out/${python3.sitePackages}/

    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck

    PYTHONPATH="" $out/bin/gyb --help > /dev/null

    runHook postCheck
  '';

  meta = with lib; {
    description = ''
      Got Your Back (GYB) is a command line tool for backing up your Gmail
      messages to your computer using Gmail's API over HTTPS.
    '';
    homepage = "https://github.com/GAM-team/got-your-back";
    license = licenses.asl20;
    mainProgram = "gyb";
    maintainers = with maintainers; [ austinbutler ];
  };
}
