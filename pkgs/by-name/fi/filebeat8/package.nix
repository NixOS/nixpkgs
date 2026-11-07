{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  systemdLibs,
  versionCheckHook,
  nix-update-script,
  withJournald ? lib.meta.availableOn stdenv.hostPlatform systemdLibs,
}:

buildGoModule (finalAttrs: {
  pname = "filebeat";
  version = "8.19.24";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "beats";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rkfXw2Qhf/cp/p1LgHrtDzE2pxNZlYktcsG7GeP5/3A=";
  };

  proxyVendor = true; # darwin/linux hash mismatch

  vendorHash = "sha256-9j31ffbzDKGDiXLqo+hSukggl9rldKDLYYRvSFI6Jaw=";

  subPackages = [ "filebeat" ];

  buildInputs = lib.optionals withJournald [ systemdLibs ];
  tags = lib.optionals withJournald [ "withjournald" ];

  postFixup = lib.optionalString withJournald ''
    patchelf --set-rpath ${lib.makeLibraryPath [ (lib.getLib systemdLibs) ]} "$out/bin/filebeat"
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version-regex=v(8\\..*)" ]; };
  };

  meta = {
    description = "Tails and ships log files";
    homepage = "https://github.com/elastic/beats";
    changelog = "https://www.elastic.co/guide/en/beats/libbeat/${lib.versions.majorMinor finalAttrs.version}/release-notes-${finalAttrs.version}.html";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ srhb ];
    mainProgram = "filebeat";
  };
})
