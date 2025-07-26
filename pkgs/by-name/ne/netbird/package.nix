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
  ui ? false,
  client ? true,
  server ? false,
  netbird-ui,
  versionCheckHook,
}:
let
  modules = lib.attrsets.mergeAttrsList [
    (lib.attrsets.optionalAttrs ui {
      "client/ui" = "netbird-ui";
    })
    (lib.attrsets.optionalAttrs client {
      client = "netbird";
    })
    (lib.attrsets.optionalAttrs server {
      management = "netbird-mgmt";
      signal = "netbird-signal";
      relay = "netbird-relay";
    })
  ];
in
buildGoModule (finalAttrs: {
  pname = "netbird";
  version = "0.49.0";

  src = fetchFromGitHub {
    owner = "netbirdio";
    repo = "netbird";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Hv0A9/NTMzRAf9YvYGvRLyy2gdigF9y2NfylE8bLcTw=";
  };

  vendorHash = "sha256-t/X/muMwHVwg8Or+pFTSEQEsnkKLuApoVUmMhyCImWI=";

  nativeBuildInputs = [ installShellFiles ] ++ lib.optional ui pkg-config;

  buildInputs = lib.optionals (stdenv.hostPlatform.isLinux && ui) [
    gtk3
    libayatana-appindicator
    libX11
    libXcursor
    libXxf86vm
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
        # relay has no completions, in which case the completion subcommand will error
        + lib.optionalString (module != "relay" && module != "client/ui") ''
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
  versionCheckProgramArg = if server then "--version" else "version";
  # Disabled for the `netbird-ui` version because it does a network request.
  doInstallCheck = !ui;

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
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      saturn745
      loc
      patrickdag
    ];
    mainProgram =
      if ui then
        "netbird-ui"
      else if server then
        "netbird-mgmt"
      else
        "netbird";
  };
})
