{
  lib,
  fetchFromGitHub,
  makeWrapper,
  openssl,
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

  patches = [ ./state-directory.patch ];

  postPatch = ''
    patchShebangs certs/gen-self-signed-cert.sh
  '';

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
      --prefix PATH : ${lib.makeBinPath [ openssl ]} \
      --add-flags "$out/share/Responder/Responder.py" \
      --run ${lib.escapeShellArg ''
        export RESPONDER_STATE_DIR="''${RESPONDER_STATE_DIR:-/tmp/Responder}"
        umask 077
      ''}

    runHook postInstall
  '';

  meta = {
    description = "LLMNR, NBT-NS and MDNS poisoner, with built-in HTTP/SMB/MSSQL/FTP/LDAP rogue authentication server";
    longDescription = ''
      Responder is an LLMNR, NBT-NS and MDNS poisoner with built-in rogue
      authentication servers for several protocols.

      The Nixpkgs package stores its runtime database, logs, captured
      credentials, and generated TLS certificates in /tmp/Responder by
      default. Set RESPONDER_STATE_DIR to use a different location, for
      example:

        sudo env RESPONDER_STATE_DIR=/var/lib/responder responder -I eth0 -v

      Runtime directories are created during normal initialization.
    '';
    homepage = "https://github.com/lgandx/Responder";
    changelog = "https://github.com/lgandx/Responder/blob/master/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "responder";
  };
})
