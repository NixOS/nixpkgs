{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nodejs,
  pnpm_9,
<<<<<<< HEAD
  fetchPnpmDeps,
  pnpmConfigHook,
}:
buildGoModule rec {
  pname = "immich-kiosk";
  version = "0.28.1";
=======
}:

buildGoModule rec {
  pname = "immich-kiosk";
  version = "0.26.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "damongolding";
    repo = "immich-kiosk";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-9ZKjhCmOL2fjGOjdzgVG7/aq6SdBJCG/+bFrlHdkll4=";
=======
    hash = "sha256-NsnJa5+P0xm12o7HAmfD8+w3H46f5WR2GO78My+YAi0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # Delete vendor directory to regenerate it consistently across platforms
  postPatch = ''
    rm -rf vendor
  '';
<<<<<<< HEAD
  vendorHash = "sha256-5y//CdHgQjNJayNI/jzdD5WPa4XlIxMonqkPc/kJp8c=";

  pnpmDeps = fetchPnpmDeps {
    inherit
      pname
      version
      src
      ;
    pnpm = pnpm_9;
    sourceRoot = "${src.name}/frontend";
    hash = "sha256-FThVaNUUE3QCbq0iPRCet4SnlHCCQaw3N5PThKSM1ek=";
=======
  vendorHash = "sha256-Mx6dCC8xRTfE/7j4chLtdKzQLHQE9y+xtEasWPtn94k=";

  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    sourceRoot = "${src.name}/frontend";
    hash = "sha256-En3y1fQRtwJm8fwxZ/VWuRfm1zPcnlDBuMNcY5WtxqM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    fetcherVersion = 2;
  };

  # Frontend is in a subdirectory
  pnpmRoot = "frontend";

  nativeBuildInputs = [
    nodejs
<<<<<<< HEAD
    pnpmConfigHook
    pnpm_9
  ];

  # Generate templ templates during vendor hash calculation
  # Don't run pnpm in this phase - filter out pnpmConfigHook
  overrideModAttrs = oldAttrs: {
    nativeBuildInputs = builtins.filter (drv: drv != pnpmConfigHook) (
=======
    pnpm_9.configHook
  ];

  # Generate templ templates during vendor hash calculation
  # Don't run pnpm in this phase - filter out pnpm.configHook
  overrideModAttrs = oldAttrs: {
    nativeBuildInputs = builtins.filter (drv: drv != pnpm_9.configHook) (
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
