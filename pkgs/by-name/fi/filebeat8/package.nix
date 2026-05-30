{
  lib,
  buildGoModule,
  fetchFromGitHub,
  systemd,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "filebeat";
  version = "8.19.16";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "beats";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OBPaSbPAp7SvhEi2yycgT70yRfCtIEdkL4/GSR2YrO4=";
  };

  proxyVendor = true; # darwin/linux hash mismatch

  vendorHash = "sha256-aCoXzWnNsctxJmsfeUyVSLkUY59adtIn2JxxGKPBob8=";

  subPackages = [ "filebeat" ];

  buildInputs = [ systemd ];
  tags = [ "withjournald" ];

  postFixup = ''
    patchelf --set-rpath ${lib.makeLibraryPath [ (lib.getLib systemd) ]} "$out/bin/filebeat"
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
    platforms = lib.platforms.linux;
  };
})
