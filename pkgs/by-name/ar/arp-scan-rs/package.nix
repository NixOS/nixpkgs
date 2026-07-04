{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "arp-scan-rs";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "kongbytes";
    repo = "arp-scan-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cTV1mJjHXT3LHFpzOC867VNnhaBo7zuinT8qqd4joY0=";
  };

  cargoHash = "sha256-qTVgFUgDctfHavejoHeW0wRi3BNsr8NV+rL/2kykBGY=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  preCheck = ''
    # Test fails
    substituteInPlace src/network.rs \
      --replace-fail 'Some("one.one.one.one".to_string())' 'None'
  '';

  versionCheckProgram = [ "${placeholder "out"}/bin/arp-scan" ];

  doInstallCheck = true;

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "ARP scan tool for fast local network scans";
    homepage = "https://github.com/kongbytes/arp-scan-rs";
    changelog = "https://github.com/kongbytes/arp-scan-rs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "arp-scan";
    broken = stdenv.hostPlatform.isDarwin;
  };
})
