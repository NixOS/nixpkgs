{
  rustPlatform,
  testers,
  libdrm,
  coolercontrol,
  runtimeShell,
  addDriverRunpath,
  python3Packages,
  liquidctl,
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

  cargoHash = "sha256-teKMz6ruTSwQ76dMXoupS3D7n1ashfHPpxMGo3Qm6FI=";

  buildInputs = [ libdrm ];

  nativeBuildInputs = [
    addDriverRunpath
    python3Packages.wrapPython
  ];

  pythonPath = [ liquidctl ];

  postPatch = ''
    # copy the frontend static resources to a directory for embedding
    mkdir -p ui-build
    cp -R ${coolercontrol.coolercontrol-ui-data}/* resources/app/

    # Hardcode a shell
    substituteInPlace src/repositories/utils.rs \
      --replace-fail 'Command::new("sh")' 'Command::new("${runtimeShell}")'
  '';

  postInstall = ''
    install -Dm444 "${src}/packaging/systemd/coolercontrold.service" -t "$out/lib/systemd/system"
    substituteInPlace "$out/lib/systemd/system/coolercontrold.service" \
      --replace-fail '/usr/bin' "$out/bin"
  '';

  postFixup = ''
    addDriverRunpath "$out/bin/coolercontrold"

    buildPythonPath "$pythonPath"
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
