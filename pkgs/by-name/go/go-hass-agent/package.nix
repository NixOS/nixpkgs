{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nodejs,
  npmHooks,
  fetchNpmDeps,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "go-hass-agent";
  version = "14.11.0";

  src = fetchFromGitHub {
    owner = "joshuar";
    repo = "go-hass-agent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mC/Y1z2kudBZOEQU5S17ROx3iHPpDGGSkUJe7MMb/iE=";
  };

  vendorHash = "sha256-Xz7u8SSlxlDB5HbKMbm1xVYrtp1/zy2yBgoWS3NcTew=";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-LwOVVVGWufQ+Q3jiv0H9lf7zg3R9fXvvAlLiUWqtmZs=";
  };

  overrideModAttrs = oldAttrs: {
    nativeBuildInputs = lib.filter (drv: drv != npmHooks.npmConfigHook) oldAttrs.nativeBuildInputs;
    preBuild = "";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  preBuild = ''
    npm run build:js
    npm run build:css
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/joshuar/go-hass-agent/config.AppVersion=v${finalAttrs.version}"
  ];

  desktopItems = [ "assets/start-go-hass-agent.desktop" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Home Assistant native app for desktop/laptop devices";
    mainProgram = "go-hass-agent";
    longDescription = ''
      Go Hass Agent is an application to expose sensors, controls, and events
      from a device to Home Assistant. You can think of it as something similar
      to the Home Assistant companion app for mobile devices, but for your
      desktop, server, Raspberry Pi, Arduino, toaster, whatever. If it can run
      Go and Linux, it can run Go Hass Agent!

      Out of the box, Go Hass Agent will report lots of details about the system
      it is running on. You can extend it with additional sensors and controls
      by hooking it up to MQTT. You can extend it even further with your own
      custom sensors and controls with scripts/programs.

      You can then use these sensors, controls, or events in any automations and
      dashboards, just like the companion app or any other “thing” you've added
      into Home Assistant.
    '';
    license = lib.licenses.mit;
    homepage = "https://github.com/joshuar/go-hass-agent";
    changelog = "https://github.com/joshuar/go-hass-agent/blob/v${finalAttrs.version}/CHANGELOG.md";
    maintainers = [ lib.maintainers.ethancedwards8 ];
    platforms = lib.platforms.linux;
  };
})
