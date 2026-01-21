{
  lib,
  fetchFromGitHub,
  buildGoModule,
  writeShellScriptBin,
  installShellFiles,
  mage,
  pkg-config,
  writableTmpDirAsHomeHook,
  libglvnd,
  xorg,
  go,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "go-hass-agent";
  version = "11.1.2";

  src = fetchFromGitHub {
    owner = "joshuar";
    repo = "go-hass-agent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ahEeZdVTL9psd+TurRxDCz7EG4AK/xW94pYImYIMsrw=";
  };

  vendorHash = "sha256-02sWRWWadZFMaLjJV181bAioNyuN7mG0ZzrkrTdUTqU=";

  nativeBuildInputs =
    let
      # dont need to pull in actual git just need the build script
      # to have this info
      fakeGit = writeShellScriptBin "git" ''
        if [[ $@ = "describe --tags --always --dirty" ]]; then
            echo "v${finalAttrs.version}"
        elif [[ $@ = "rev-parse --short HEAD" ]]; then
            echo ""
        elif [[ $@ = "log --date=iso8601-strict -1 --pretty=%ct" ]]; then
            echo "0"
        else
            >&2 echo "Unknown command: $@"
            exit 1
        fi
      '';
    in
    [
      fakeGit
      installShellFiles
      mage
      pkg-config
      writableTmpDirAsHomeHook
    ];

  buildInputs = [
    libglvnd
    xorg.libXcursor
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXxf86vm
  ];

  desktopItems = [ "assets/go-hass-agent.desktop" ];

  buildPhase = ''
    runHook preBuild

    mage -d build/magefiles -w . build:full

    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck

    mage -d build/magefiles -w . tests:test

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    installBin dist/go-hass-agent-${go.GOARCH}

    runHook postInstall
  '';

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
