{
  lib,
  buildGo127Module,
  fleet-orbit,
  gtk3,
  libayatana-appindicator,
  nixosTests,
  pkg-config,
  versionCheckHook,
}:

buildGo127Module {
  pname = "fleet-desktop";
  inherit (fleet-orbit) version src vendorHash;
  __structuredAttrs = true;

  env.CGO_ENABLED = "1";

  subPackages = [ "orbit/cmd/desktop" ];

  goFlags = [ "-buildvcs=false" ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${fleet-orbit.version}"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gtk3
    libayatana-appindicator
  ];

  postInstall = ''
    mv "$out/bin/desktop" "$out/bin/fleet-desktop"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  postInstallCheck = ''
    test ! -e "$out/bin/.fleet-desktop-wrapped"
  '';

  passthru.tests = {
    inherit (nixosTests) orbit;
  };

  meta = {
    description = "Fleet's desktop tray application";
    homepage = "https://github.com/fleetdm/fleet";
    changelog = "https://github.com/fleetdm/fleet/pull/54098";
    license = lib.licenses.mit;
    mainProgram = "fleet-desktop";
    maintainers = with lib.maintainers; [
      adrielvelazquez
      faukah
    ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
