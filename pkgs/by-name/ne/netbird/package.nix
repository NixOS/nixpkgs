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
  darwin,
  ui ? false,
  netbird-ui,
  versionCheckHook,
}:
let
  modules =
    if ui then
      {
        "client/ui" = "netbird-ui";
      }
    else
      {
        client = "netbird";
        management = "netbird-mgmt";
        signal = "netbird-signal";
      };
in
buildGoModule (finalAttrs: {
  pname = "netbird";
  version = "0.38.2";

  src = fetchFromGitHub {
    owner = "netbirdio";
    repo = "netbird";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8uxRR8XkomUB9dMN9h1M4/K09wxy5E+XhXVbNc0g6xQ=";
  };

  vendorHash = "sha256-m5ou5p2/ubDDMLr0M2F+9qgkqKjhXRJ6HpizwxJhmtU=";

  nativeBuildInputs = [ installShellFiles ] ++ lib.optional ui pkg-config;

  buildInputs =
    lib.optionals (stdenv.hostPlatform.isLinux && ui) [
      gtk3
      libayatana-appindicator
      libX11
      libXcursor
      libXxf86vm
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && ui) [
      darwin.apple_sdk.frameworks.Cocoa
      darwin.apple_sdk.frameworks.IOKit
      darwin.apple_sdk.frameworks.Kernel
      darwin.apple_sdk.frameworks.UserNotifications
      darwin.apple_sdk.frameworks.WebKit
    ];

  subPackages = lib.attrNames modules;

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
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        module: binary:
        ''
          mv $out/bin/${lib.last (lib.splitString "/" module)} $out/bin/${binary}
        ''
        + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform && !ui) ''
          installShellCompletion --cmd ${binary} \
            --bash <($out/bin/${binary} completion bash) \
            --fish <($out/bin/${binary} completion fish) \
            --zsh <($out/bin/${binary} completion zsh)
        ''
      ) modules
    )
    + lib.optionalString (stdenv.hostPlatform.isLinux && ui) ''
      install -Dm644 "$src/client/ui/assets/netbird-systemtray-connected.png" "$out/share/pixmaps/netbird.png"
      install -Dm644 "$src/client/ui/build/netbird.desktop" "$out/share/applications/netbird.desktop"

      substituteInPlace $out/share/applications/netbird.desktop \
        --replace-fail "Exec=/usr/bin/netbird-ui" "Exec=$out/bin/netbird-ui"
    '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru = {
    tests.netbird = nixosTests.netbird;
    tests.netbird-ui = netbird-ui;
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://netbird.io";
    changelog = "https://github.com/netbirdio/netbird/releases/tag/v${finalAttrs.version}";
    description = "Connect your devices into a single secure private WireGuard®-based mesh network with SSO/MFA and simple access controls";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      vrifox
      saturn745
    ];
    mainProgram = if ui then "netbird-ui" else "netbird";
  };
})
