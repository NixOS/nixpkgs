{
  stdenv,
  lib,
  nixosTests,
  nix-update-script,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  wails3,
  imagemagick,
  fetchPnpmDeps,
  nodejs,
  pnpmConfigHook,
  pnpm_11,
  versionCheckHook,
  netbird-management,
  netbird-proxy,
  netbird-relay,
  netbird-signal,
  netbird-ui,
  netbird-upload,
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
    proxy = {
      module = "proxy/cmd/proxy";
      binaryName = "netbird-proxy";
      license = lib.licenses.agpl3Only;
    };
  };
  component = availableComponents.${componentName};
in
buildGoModule (finalAttrs: {
  pname = "netbird-${componentName}";
  version = "0.75.0-rc.3";

  src = fetchFromGitHub {
    owner = "netbirdio";
    repo = "netbird";
    tag = "v${finalAttrs.version}";
    hash = "sha256-75aRmLmA6vfu0V5vnrjiZmpr0js9TvV2CSAr4tULNtg=";
  };

  proxyVendor = true;
  vendorHash = "sha256-P3btLPC0kOXMVw1C2je0D4SqwCnhmWruyqmNIMQOLJ0=";

  overrideModAttrs = final: prev: {
    # override output name so that we don't download the same modules every time
    # for every component of the monorepo
    name = "netbird-${finalAttrs.version}-go-modules";

    # don't call pnpm when building modules
    dontPnpmConfigure = true;
    preBuild = null;
  };

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals (componentName == "ui") [
    nodejs
    pnpmConfigHook
    pnpm_11
    wails3
    # to convert the icons
    imagemagick
  ];

  pnpmRoot = "client/ui/frontend";

  pnpmDeps = fetchPnpmDeps {
    pname = "netbird";
    inherit (finalAttrs)
      version
      src
      ;

    sourceRoot = "${finalAttrs.src.name}/client/ui/frontend";

    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-T4E4GJgsoMZnLokJRuDm1L43OrYF99PLF4x/4HRIB4E=";
  };

  preBuild = lib.optionalString (componentName == "ui") ''
    pushd client/ui/frontend
    pnpm run bindings
    pnpm build
    popd
  '';

  subPackages = [ component.module ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/netbirdio/netbird/version.version=v${finalAttrs.version}"
    "-X main.builtBy=nix"
  ];

  # needs network access
  doCheck = false;

  postPatch = ''
    # make it compatible with systemd's RuntimeDirectory
    substituteInPlace client/cmd/root.go \
      --replace-fail 'unix:///var/run/netbird.sock' 'unix:///var/run/netbird/sock'
    substituteInPlace client/ui/grpc.go \
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
    + lib.optionalString (stdenv.hostPlatform.isLinux && componentName == "ui") ''
      install -Dm644 $src/client/ui/build/linux/netbird.desktop $out/share/applications/netbird.desktop

      for RES in 16 24 32 48 64 128 256 512 1024
      do
        mkdir -p $out/share/icons/hicolor/"$RES"x"$RES"/apps
        convert $src/client/ui/build/appicon.png -resize "$RES"x"$RES" $out/share/icons/hicolor/"$RES"x"$RES"/apps/netbird.png
      done

      substituteInPlace $out/share/applications/netbird.desktop \
        --replace-fail "/usr/bin/netbird-ui" "${component.binaryName}"
    '';

  nativeInstallCheckInputs = lib.lists.optionals (component ? versionCheckProgramArg) [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/${component.binaryName}";
  versionCheckProgramArg = component.versionCheckProgramArg or "version";

  passthru = {
    tests = lib.attrsets.optionalAttrs (componentName == "client") {
      nixos = nixosTests.netbird;
      inherit
        # make sure child packages are built by `ofborg`
        netbird-management
        netbird-relay
        netbird-signal
        netbird-ui
        netbird-upload
        netbird-proxy
        ;
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
