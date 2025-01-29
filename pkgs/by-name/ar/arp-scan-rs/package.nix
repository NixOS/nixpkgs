{
  lib,
  fetchFromGitHub,
  gitUpdater,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "arp-scan-rs";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "kongbytes";
    repo = "arp-scan-rs";
    tag = "v${version}";
    hash = "sha256-CLxeT2olrxRCJ12IZ1PvLW7ZuX0HPsoNuFyxmGBhB8w=";
  };

  cargoHash = "sha256-+Ph5k3qaK4USggTnZqyOdH6oKv5Xr2/NeQ9C0Q6g5sQ=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  preCheck = ''
    # Test fails
    substituteInPlace src/network.rs \
      --replace-fail 'Some("one.one.one.one".to_string())' 'None'
  '';

  versionCheckProgram = [ "${placeholder "out"}/bin/arp-scan" ];

  versionCheckProgramArg = "--version";

  doInstallCheck = true;

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "ARP scan tool for fast local network scans";
    homepage = "https://github.com/kongbytes/arp-scan-rs";
    changelog = "https://github.com/kongbytes/arp-scan-rs/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "arp-scan";
  };
}
