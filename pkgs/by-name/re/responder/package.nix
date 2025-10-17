{
  lib,
  fetchFromGitHub,
  makeWrapper,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "responder";
  version = "3.1.7.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "lgandx";
    repo = "Responder";
    tag = "v${version}";
    hash = "sha256-ZC74VFnixSc97fRkRSOJmc39YLIP95qAUFydIcyzNdo=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  dependencies = with python3.pkgs; [
    aioquic
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
      --replace-fail "Responder-Session.log" "/tmp/Responder/Responder-Session.log" \
      --replace-fail "Poisoners-Session.log" "/tmp/Responder/Poisoners-Session.log" \
      --replace-fail "Analyzer-Session.log" "/tmp/Responder/Analyzer-Session" \
      --replace-fail "Config-Responder.log" "/tmp/Responder/Config-Responder.log" \
      --replace-fail "Responder.db" "/tmp/Responder/Responder.db"

    runHook postInstall
  '';

  meta = {
    description = "LLMNR, NBT-NS and MDNS poisoner, with built-in HTTP/SMB/MSSQL/FTP/LDAP rogue authentication server";
    homepage = "https://github.com/lgandx/Responder";
    changelog = "https://github.com/lgandx/Responder/blob/master/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "responder";
  };
}
