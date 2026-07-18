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
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "damongolding";
    repo = "immich-kiosk";
    tag = "v${version}";
    hash = "sha256-mr0cxHdekpzfKfJ2IKpm79vTu5qnSl8q2c8eWose7tg=";
  };

  postPatch = ''
    # Delete vendor directory to regenerate it consistently across platforms
    rm -rf vendor
    # immich-kiosk bumps go at a faster cadence than nixpkgs
    sed -i -E 's/^go 1\.26\.[0-9]+$/go 1.26/' go.mod
  '';
  vendorHash = "sha256-5mMU73/XvHfvT8VaseSymZjDalvHj/KR6cTz1nvXHPQ=";
  proxyVendor = true;

  npmDeps = fetchNpmDeps {
    inherit src;
    sourceRoot = "${src.name}/frontend";
    hash = "sha256-1m0JvPZDYjd2cNy9atENRS3/GHWzLnPISwGnJbSZwAo=";
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
