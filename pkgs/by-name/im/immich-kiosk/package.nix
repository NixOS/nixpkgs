{
  lib,
  buildGoLatestModule, # upstream bumps go every release
  fetchFromGitHub,
  nodejs,
  fetchNpmDeps,
  npmHooks,
  go-task,
}:

buildGoLatestModule rec {
  pname = "immich-kiosk";
  version = "0.43.1";

  src = fetchFromGitHub {
    owner = "damongolding";
    repo = "immich-kiosk";
    tag = "v${version}";
    hash = "sha256-6Z6tp+YGlh3Gk31ZvQQ+F/DLvnGx571cRXv54rrC0D4=";
  };

  postPatch = ''
    # Delete vendor directory to regenerate it consistently across platforms
    rm -rf vendor
    # immich-kiosk bumps go at a faster cadence than nixpkgs
    sed -i -E 's/^go 1\.27\.[0-9]+$/go 1.27/' go.mod
  '';
  vendorHash = "sha256-/kyQSoI398crsqX71IgaXepUAI2hEEwr8CRInF6zXeM=";
  proxyVendor = true;

  npmDeps = fetchNpmDeps {
    inherit src;
    sourceRoot = "${src.name}/frontend";
    hash = "sha256-x4D+t0bfyJkp1i4SOwfZNw+jiz5gsb+RzQAQLH4XI4s=";
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
    maintainers = with lib.maintainers; [
      tlvince
      esch
    ];
    mainProgram = "immich-kiosk";
  };
}
