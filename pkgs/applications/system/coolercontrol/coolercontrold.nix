{
  lib,
  rustPlatform,
  testers,
  hwdata,
  pkg-config,
  libdrm,
  libglvnd,
  vulkan-loader,
  coolercontrol,
  runtimeShell,
  addDriverRunpath,
  python3Packages,
  liquidctl,
  which,
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

  cargoHash = "sha256-tbGNVyYrTRmxOqVM7mjNgwZXXcUY205mKuFjrptr+m4=";

  buildInputs = [
    hwdata
    libdrm
    libglvnd
    vulkan-loader
  ];

  nativeBuildInputs = [
    pkg-config
    addDriverRunpath
    python3Packages.wrapPython
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

    patchelf --add-rpath ${
      lib.strings.makeLibraryPath [
        # could instead patch out dynamic_loading for libdrm_amdgpu_sys in daemon/Cargo.toml,
        # but we have to add other libraries to the search path anyway
        libdrm

        # Finding GPUs for stress-testing
        libglvnd
        vulkan-loader
      ]
    } $out/bin/coolercontrold

    buildPythonPath "''${pythonPath[*]}"
    wrapProgram "$out/bin/coolercontrold" \
      --prefix PATH : ${lib.makeBinPath [ which ]} \
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
