{
  lib,
  fetchFromGitHub,
  python3Packages,
  makeWrapper,
  metasploit,
}:

python3Packages.buildPythonApplication rec {
  pname = "social-engineer-toolkit";
  version = "8.0.3";
  format = "other";

  src = fetchFromGitHub {
    owner = "trustedsec";
    repo = pname;
    rev = version;
    sha256 = "ePbmUvnzLO0Wfuhym3bNSPV1x8rcCPqKMeWSRcbJGAo=";
  };

  postPatch = ''
    substituteInPlace setoolkit \
      --replace "src/core/config.baseline" "$out/share/social-engineer-toolkit/src/core/config.baseline"
    substituteInPlace src/core/setcore.py \
      --replace '"src/core/set.version"' "\"$out/share/social-engineer-toolkit/src/core/set.version\"" \
      --replace "/opt/metasploit-framework" "${metasploit}/bin"
  '';

  nativeBuildInputs = [
    makeWrapper
  ];

  propagatedBuildInputs = with python3Packages; [
    pexpect
    pycrypto
    requests
    pyopenssl
    pefile
    impacket
    qrcode
    pillow
    # Has been abandoned upstream. Features using this library are broken
    # pymssql
  ];

  installPhase = ''
    runHook preInstall

    install -Dt $out/bin setoolkit seautomate seproxy
    mkdir -p $out/share/social-engineer-toolkit
    cp -r modules readme src $out/share/social-engineer-toolkit/

    runHook postInstall
  '';

  makeWrapperArgs = [
    "--chdir ${placeholder "out"}/share/social-engineer-toolkit"
    "--prefix PYTHONPATH : \"${placeholder "out"}/share/social-engineer-toolkit\""
  ];

  # Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "Open-source penetration testing framework designed for social engineering";
    longDescription = ''
      The Social-Engineer Toolkit is an open-source penetration testing framework
      designed for social engineering. SET has a number of custom attack vectors
      that allow you to make a believable attack quickly.
    '';
    homepage = "https://github.com/trustedsec/social-engineer-toolkit";
    mainProgram = "setoolkit";
    license = licenses.bsd3;
    maintainers = with maintainers; [ emilytrau ];
  };
}
