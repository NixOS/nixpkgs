{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
  writeShellScriptBin,
  pkg-config,
  gcc,
  glibc,
  mage,
  libglvnd,
  xorg,
}:
buildGoModule rec {
  pname = "go-hass-agent";
  version = "11.1.2";

  src = fetchFromGitHub {
    owner = "joshuar";
    repo = pname;
    tag = "v11.1.2";
    hash = "sha256-c2TldMY05Au4gwYiIDPi/gQuOHVnT+/0ycgGHKErZyA=";
  };

  vendorHash = "sha256-02sWRWWadZFMaLjJV181bAioNyuN7mG0ZzrkrTdUTqU=";

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs =
    let
      fakeGit = writeShellScriptBin "git" ''
        if [[ $@ = "describe --tags --always --dirty" ]]; then
            echo "v${version}"
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
      pkg-config
      gcc
      mage
      fakeGit
    ];
  buildInputs = [
    libglvnd
    glibc.static
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXcursor
    xorg.libXi
    xorg.libXxf86vm
  ];

  CFLAGS = "-I${glibc.dev}/include";
  LDFLAGS = "-L${glibc}/lib";

  desktopItems = [ "assets/go-hass-agent.desktop" ];

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
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

    install -DT dist/go-hass-agent-$(go env GOARCH) $out/bin/go-hass-agent

    runHook postInstall
  '';

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
    changelog = "https://github.com/joshuar/go-hass-agent/blob/v${version}/CHANGELOG.md";
    maintainers = [ lib.maintainers.briaoeuidhtns ];
    platforms = lib.platforms.linux;
  };
}
