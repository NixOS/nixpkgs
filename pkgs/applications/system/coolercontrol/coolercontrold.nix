{
  rustPlatform,
  testers,
  libdrm,
  coolercontrol,
  runtimeShell,
}:

{
  version,
  src,
  meta,
}:

rustPlatform.buildRustPackage {
  pname = "coolercontrold";
  inherit version src;
  sourceRoot = "${src.name}/coolercontrold";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "nvml-wrapper-0.10.0" = "sha256-pMiULWT+nJXcDfLDeACG/DaPF5+AbzpoIUWWWz8mQ+0=";
    };
  };

  buildInputs = [
    libdrm
  ];

  postPatch = ''
    # copy the frontend static resources to a directory for embedding
    mkdir -p ui-build
    cp -R ${coolercontrol.coolercontrol-ui-data}/* ui-build/
    substituteInPlace build.rs --replace '"./resources/app"' '"./ui-build"'

    # Hardcode a shell
    substituteInPlace src/repositories/utils.rs \
      --replace-fail 'Command::new("sh")' 'Command::new("${runtimeShell}")'
  '';

  postInstall = ''
    install -Dm444 "${src}/packaging/systemd/coolercontrold.service" -t "$out/lib/systemd/system"
    substituteInPlace "$out/lib/systemd/system/coolercontrold.service" \
      --replace '/usr/bin' "$out/bin"
  '';

  passthru.tests.version = testers.testVersion {
    package = coolercontrol.coolercontrold;
    # coolercontrold prints its version with "v" prefix
    version = "v${version}";
  };

  meta = meta // {
    description = "${meta.description} (Main Daemon)";
    mainProgram = "coolercontrold";
  };
}
