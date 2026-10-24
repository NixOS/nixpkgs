{
  lib,
  fetchFromGitHub,
  makeWrapper,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "responder";
  version = "3.2.2.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "lgandx";
    repo = "Responder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vzn+7w7RgAsCt1pOz53cvBE1F1U+NFE4c1MehwLoFeQ=";
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

    # === Fix 1: Responder don't want to print hashes in console ===
    # settings.py nails LogDir to ResponderPATH (the store),
    # and utils.py in SaveToDb() rebuilds the same path by hand.
    # The failing write into the read-only store aborts the function right before print().
    # Redirect both paths to /tmp/Responder/logs (where the DB and session logs already live).
    substituteInPlace $out/share/Responder/settings.py \
      --replace-fail "self.LogDir = os.path.join(self.ResponderPATH, 'logs')" \
                    "self.LogDir = '/tmp/Responder/logs'" \
      --replace-fail "os.mkdir(self.LogDir)" \
                    "os.makedirs(self.LogDir, exist_ok=True)"

    substituteInPlace $out/share/Responder/utils.py \
      --replace-fail "os.path.join(settings.Config.ResponderPATH, 'logs', fname)" \
                    "os.path.join(settings.Config.LogDir, fname)"

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
})
