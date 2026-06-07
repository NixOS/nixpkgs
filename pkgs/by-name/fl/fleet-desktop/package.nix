{
  lib,
  buildGoModule,
  fleet-orbit,
  gtk3,
  libayatana-appindicator,
  nixosTests,
  pkg-config,
  versionCheckHook,
}:

buildGoModule {
  pname = "fleet-desktop";
  inherit (fleet-orbit) version src;
  __structuredAttrs = true;

  vendorHash = "sha256-fhACxmzJY0PEQmMbjQxlfQh5ZJ+7a4um0s8xFQq+57w=";

  env.CGO_ENABLED = "1";

  subPackages = [ "orbit/cmd/desktop" ];

  goFlags = [ "-buildvcs=false" ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${fleet-orbit.version}"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gtk3
    libayatana-appindicator
  ];

  postInstall = ''
    mv "$out/bin/desktop" "$out/bin/fleet-desktop"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.tests = {
    inherit (nixosTests) orbit;
  };

  meta = {
    description = "Fleet's desktop tray application";
    homepage = "https://github.com/fleetdm/fleet";
    changelog = "https://github.com/fleetdm/fleet/releases/tag/orbit-v${fleet-orbit.version}";
    license = lib.licenses.mit;
    mainProgram = "fleet-desktop";
    maintainers = with lib.maintainers; [ adrielvelazquez ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
