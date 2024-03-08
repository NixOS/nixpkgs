{ rustPlatform
, buildNpmPackage
, testers
, coolercontrol
}:

{ version
, src
, meta
}:

rustPlatform.buildRustPackage {
  pname = "coolercontrold";
  inherit version src;
  sourceRoot = "${src.name}/coolercontrold";

  cargoHash = "sha256-Ybqr36AkcPnGJeFcCqg/zuWcaooZ1gJPCi5IbgXmeJ0=";

  # copy the frontend static resources to a directory for embedding
  postPatch = ''
    mkdir -p ui-build
    cp -R ${coolercontrol.coolercontrol-ui-data}/* ui-build/
    substituteInPlace build.rs --replace '"./resources/app"' '"./ui-build"'
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
