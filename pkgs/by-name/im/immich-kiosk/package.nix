{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nodejs,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
}:
buildGoModule rec {
  pname = "immich-kiosk";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "damongolding";
    repo = "immich-kiosk";
    tag = "v${version}";
    hash = "sha256-PHdHhhVy0RWMFzR4ZEyWLOiRYHROadLiPIdqkUZMTow=";
  };

  # Delete vendor directory to regenerate it consistently across platforms
  postPatch = ''
    rm -rf vendor
  '';
  vendorHash = "sha256-3M3fXwCkljfY8wjXf+PdcbqnkyPKaDCJWt9/nRA/+Dc=";
  proxyVendor = true;

  pnpmDeps = fetchPnpmDeps {
    inherit
      pname
      version
      src
      ;
    pnpm = pnpm_9;
    sourceRoot = "${src.name}/frontend";
    hash = "sha256-ELIbM+tWOGntv8XmNvRZ/Q2iSRq0g9Kv5LnkwLPisPM=";
    fetcherVersion = 2;
  };

  # Frontend is in a subdirectory
  pnpmRoot = "frontend";

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_9
  ];

  # Generate templ templates during vendor hash calculation
  # Don't run pnpm in this phase - filter out pnpmConfigHook
  overrideModAttrs = oldAttrs: {
    nativeBuildInputs = builtins.filter (drv: drv != pnpmConfigHook) (
      oldAttrs.nativeBuildInputs or [ ]
    );
    preBuild = ''
      go run github.com/a-h/templ/cmd/templ generate
    '';
  };

  # Generate templ templates and build frontend assets before Go build
  # Frontend assets are embedded into the binary via go:embed
  preBuild = ''
    go run github.com/a-h/templ/cmd/templ generate

    pushd frontend
    pnpm build
    popd
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  # Tests require network access to an Immich server
  doCheck = false;

  meta = {
    description = "Lightweight slideshow for running on kiosk devices and browsers that uses Immich as a data source";
    longDescription = ''
      Immich Kiosk is a lightweight slideshow for running on kiosk devices and
      browsers that uses Immich as a data source. It displays photos and videos
      from your Immich server in a configurable slideshow format, perfect for
      digital photo frames and kiosk displays.

      This is not an official Immich project and is not affiliated with Immich.
    '';
    homepage = "https://github.com/damongolding/immich-kiosk";
    changelog = "https://github.com/damongolding/immich-kiosk/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ tlvince ];
    mainProgram = "immich-kiosk";
  };
}
