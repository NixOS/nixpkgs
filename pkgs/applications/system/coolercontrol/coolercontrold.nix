{
  rustPlatform,
  testers,
  hwdata,
  pkg-config,
  libdrm,
  coolercontrol,
  runtimeShell,
  addDriverRunpath,
  python3Packages,
  liquidctl,
  protobuf,
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

  cargoHash = "sha256-DE1m/odw90epyR8U9H1pxyJXariIHLXwk+mVYi8cu5A=";

  buildInputs = [
    hwdata
    libdrm
  ];

  nativeBuildInputs = [
    pkg-config
    protobuf
    addDriverRunpath
    python3Packages.wrapPython
  ];

  checkFlags = [
    # This test has a build-machine dependency and will be removed from the normal test suite in the next release
    "--skip=repositories::hwmon::hwmon_repo::coalescer_tests::fast_device_no_added_latency"
  ];

  pythonPath = [ liquidctl ];

  postPatch = ''
    # copy the frontend static resources to a directory for embedding
    mkdir -p ui-build
    cp -R ${coolercontrol.coolercontrol-ui-data}/* resources/app/

    # Hardcode a shell
    substituteInPlace daemon/src/repositories/utils.rs \
      --replace-fail 'Command::new("sh")' 'Command::new("${runtimeShell}")'
  '';

  postInstall = ''
    install -Dm444 "${src}/packaging/systemd/coolercontrold.service" -t "$out/lib/systemd/system"
    substituteInPlace "$out/lib/systemd/system/coolercontrold.service" \
      --replace-fail '/usr/bin' "$out/bin"
  '';

  postFixup = ''
    addDriverRunpath "$out/bin/coolercontrold"

    buildPythonPath "''${pythonPath[*]}"
    wrapProgram "$out/bin/coolercontrold" \
      --prefix PATH : $program_PATH \
      --prefix PYTHONPATH : $program_PYTHONPATH
  '';

  passthru.tests.version = testers.testVersion {
    package = coolercontrol.coolercontrold;
  };

  meta = meta // {
    description = "${meta.description} (Main Daemon)";
    mainProgram = "coolercontrold";
  };
}
