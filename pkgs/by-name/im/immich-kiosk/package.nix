{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nodejs,
  fetchNpmDeps,
  npmHooks,
  go-task,
}:

buildGoModule rec {
  pname = "immich-kiosk";
  version = "0.39.3";

  src = fetchFromGitHub {
    owner = "damongolding";
    repo = "immich-kiosk";
    tag = "v${version}";
    hash = "sha256-kdTEvH8MqL3oXe0QZlPTVpeByLpqAdNfPGfu5f2G6g0=";
  };

  postPatch = ''
    # Delete vendor directory to regenerate it consistently across platforms
    rm -rf vendor
    # immich-kiosk bumps go at a faster cadence than nixpkgs
    sed 's/^go 1\.26\.\d+$/go 1.26/' go.mod
  '';
  vendorHash = "sha256-y6Xl00G+mkhRKVGwMS0WCXZhQqqGGX5qY8PhMxtw7z8=";
  proxyVendor = true;

  npmDeps = fetchNpmDeps {
    inherit src;
    sourceRoot = "${src.name}/frontend";
    hash = "sha256-lNON0/lxix2aczC0+m7Er5Te1+4fsSoLkk6Z2pYzQYQ=";
  };
  # Frontend is in a subdirectory
  npmRoot = "frontend";

  nativeBuildInputs = [
    nodejs
    go-task
    npmHooks.npmConfigHook
  ];

  # Generate templ templates during vendor hash calculation
  # Don't run npm in this phase - filter out npmConfigHook
  overrideModAttrs = oldAttrs: {
    nativeBuildInputs = builtins.filter (drv: drv != npmHooks.npmConfigHook) (
      oldAttrs.nativeBuildInputs or [ ]
    );
    preBuild = ''
      go tool templ generate
    '';
  };

  # Generate templ templates and build frontend assets before Go build
  # Frontend assets are embedded into the binary via go:embed
  preBuild = ''
    go tool templ generate
    task frontend
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
