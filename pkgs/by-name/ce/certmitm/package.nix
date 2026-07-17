{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication {
  pname = "certmitm";
  version = "0-unstable-2025-05-14";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "aapooksman";
    repo = "certmitm";
    rev = "f04c91a1ba231762ec126487f593f9b4d33f4ec2";
    hash = "sha256-i4DnOyn56lA63hI40uxtXX8dzMa29BPQQHWKFdVjVlM=";
  };

  dependencies = with python3.pkgs; [
    dpkt
    pyopenssl
  ];

  installPhase = ''
    runHook preInstall

    install -vD certmitm.py $out/bin/certmitm
    install -vd $out/${python3.sitePackages}/
    cp -R certmitm $out/${python3.sitePackages}

    runHook postInstall
  '';

  # Project has not tests
  doCheck = false;

  meta = {
    description = "Tool for testing for certificate validation vulnerabilities of TLS connections";
    homepage = "https://github.com/aapooksman/certmitm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "certmitm";
    platforms = lib.platforms.all;
  };
}
