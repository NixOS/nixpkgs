{ lib
, fetchFromGitHub
, makeWrapper
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "responder";
  version = "3.1.4.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "lgandx";
    repo = "Responder";
    rev = "refs/tags/v${version}";
    hash = "sha256-BVSA/ZhpGz6UGyDRJUc4nlRJZ1/Y7er1vVOI+IbIqGk=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  propagatedBuildInputs = with python3.pkgs; [
    netifaces
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share $out/share/Responder
    cp -R . $out/share/Responder

    makeWrapper ${python3.interpreter} $out/bin/responder \
      --set PYTHONPATH "$PYTHONPATH:$out/bin/Responder.py" \
      --add-flags "$out/share/Responder/Responder.py" \
      --run "mkdir -p /tmp/Responder"

    substituteInPlace $out/share/Responder/Responder.conf \
      --replace "Responder-Session.log" "/tmp/Responder/Responder-Session.log" \
      --replace "Poisoners-Session.log" "/tmp/Responder/Poisoners-Session.log" \
      --replace "Analyzer-Session.log" "/tmp/Responder/Analyzer-Session" \
      --replace "Config-Responder.log" "/tmp/Responder/Config-Responder.log" \
      --replace "Responder.db" "/tmp/Responder/Responder.db"

    runHook postInstall
  '';

  meta = with lib; {
    description = "LLMNR, NBT-NS and MDNS poisoner, with built-in HTTP/SMB/MSSQL/FTP/LDAP rogue authentication server";
    mainProgram = "responder";
    homepage = "https://github.com/lgandx/Responder";
    changelog = "https://github.com/lgandx/Responder/blob/master/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
