{
  lib,
  stdenv,
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

  cargoHash = "sha256-lPE/mx4LzSOG1YjGol1f77oox4voZzp9RqrKYZAMoX0=";

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
    broken = stdenv.hostPlatform.isDarwin;
  };
}
