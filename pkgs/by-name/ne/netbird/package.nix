{
  stdenv,
  lib,
  nixosTests,
  nix-update-script,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  gtk3,
  libayatana-appindicator,
  libX11,
  libXcursor,
  libXxf86vm,
  netbird-ui,
  versionCheckHook,
  componentName ? "client",
}:
let
  /*
    License tagging is based off:
    - https://github.com/netbirdio/netbird/blob/9e95841252c62b50ae93805c8dfd2b749ac95ea7/LICENSES/REUSE.toml
    - https://github.com/netbirdio/netbird/blob/9e95841252c62b50ae93805c8dfd2b749ac95ea7/LICENSE#L1-L2
  */
  availableComponents = {
    client = {
      module = "client";
      binaryName = "netbird";
      license = lib.licenses.bsd3;
      versionCheckProgramArg = "version";
      hasCompletion = true;
    };
    ui = {
      module = "client/ui";
      binaryName = "netbird-ui";
      license = lib.licenses.bsd3;
    };
    upload = {
      module = "upload-server";
      binaryName = "netbird-upload";
      license = lib.licenses.bsd3;
    };
    management = {
      module = "management";
      binaryName = "netbird-mgmt";
      license = lib.licenses.agpl3Only;
      versionCheckProgramArg = "--version";
      hasCompletion = true;
    };
    signal = {
      module = "signal";
      binaryName = "netbird-signal";
      license = lib.licenses.agpl3Only;
      hasCompletion = true;
    };
    relay = {
      module = "relay";
      binaryName = "netbird-relay";
      license = lib.licenses.agpl3Only;
    };
  };
  isUI = componentName == "ui";
  component = availableComponents.${componentName};
in
buildGoModule (finalAttrs: {
  pname = "netbird-${componentName}";
  version = "0.54.0";

  src = fetchFromGitHub {
    owner = "netbirdio";
    repo = "netbird";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qKYJa7q7scEbbxLHaosaurrjXR5ABxCAnuUcy80yKEc=";
  };

  vendorHash = "sha256-uVVm+iDGP2eZ5GVXWJrWZQ7LpHdZccRIiHPIFs6oAPo=";

  nativeBuildInputs = [ installShellFiles ] ++ lib.optional isUI pkg-config;

  buildInputs = lib.optionals (stdenv.hostPlatform.isLinux && isUI) [
    gtk3
    libayatana-appindicator
    libX11
    libXcursor
    libXxf86vm
  ];

  subPackages = [ component.module ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/netbirdio/netbird/version.version=${finalAttrs.version}"
    "-X main.builtBy=nix"
  ];

  # needs network access
  doCheck = false;

  postPatch = ''
    # make it compatible with systemd's RuntimeDirectory
    substituteInPlace client/cmd/root.go \
      --replace-fail 'unix:///var/run/netbird.sock' 'unix:///var/run/netbird/sock'
    substituteInPlace client/ui/client_ui.go \
      --replace-fail 'unix:///var/run/netbird.sock' 'unix:///var/run/netbird/sock'
  '';

  postInstall =
    let
      builtBinaryName = lib.last (lib.splitString "/" component.module);
    in
    ''
      mv $out/bin/${builtBinaryName} $out/bin/${component.binaryName}
    ''
    +
      lib.optionalString
        (stdenv.buildPlatform.canExecute stdenv.hostPlatform && (component.hasCompletion or false))
        ''
          installShellCompletion --cmd ${component.binaryName} \
            --bash <($out/bin/${component.binaryName} completion bash) \
            --fish <($out/bin/${component.binaryName} completion fish) \
            --zsh <($out/bin/${component.binaryName} completion zsh)
        ''
    # assemble & adjust netbird.desktop files for the GUI
    + lib.optionalString (stdenv.hostPlatform.isLinux && isUI) ''
      install -Dm644 "$src/client/ui/assets/netbird-systemtray-connected.png" "$out/share/pixmaps/netbird.png"
      install -Dm644 "$src/client/ui/build/netbird.desktop" "$out/share/applications/netbird.desktop"

      substituteInPlace $out/share/applications/netbird.desktop \
        --replace-fail "Exec=/usr/bin/netbird-ui" "Exec=$out/bin/${component.binaryName}"
    '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/${component.binaryName}";
  versionCheckProgramArg = component.versionCheckProgramArg or "version";
  doInstallCheck = component ? versionCheckProgramArg;

  passthru = {
    tests = {
      nixos = nixosTests.netbird;
      withUI = netbird-ui;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://netbird.io";
    changelog = "https://github.com/netbirdio/netbird/releases/tag/v${finalAttrs.version}";
    description = "Connect your devices into a single secure private WireGuard®-based mesh network with SSO/MFA and simple access controls";
    license = component.license;
    maintainers = with lib.maintainers; [
      nazarewk
      saturn745
      loc
    ];
    mainProgram = component.binaryName;
  };
})
