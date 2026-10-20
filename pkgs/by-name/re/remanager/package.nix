{
  buildGoModule,
  copyDesktopItems,
  fetchFromGitHub,
  fetchNpmDeps,
  lib,
  nodejs,
  npmHooks,
  pkg-config,
  wails,
  webkitgtk_4_1,
}:
buildGoModule (finalAttrs: {
  pname = "remanager";
  version = "1.7.4";
  src = fetchFromGitHub {
    owner = "rmitchellscott";
    repo = "reManager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V52JaZ2a8TM0PkcVFqRYohX9Y0SLUHTLQu8+huvhAdE=";
  };
  vendorHash = "sha256-YC/Z9rn3DUZkuYHyDyOAmbugMFUx2sIWlrtMDyUXhUw=";

  __structuredAttrs = true;

  # buildGoModule is responsible for preparing the source, and building *just* the CLI
  subPackages = [ "cmd/remanager" ];
  ldflags = [ "-X main.version=${finalAttrs.version}" ];

  nativeBuildInputs = [
    copyDesktopItems
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    wails
  ];

  buildInputs = [ webkitgtk_4_1 ];

  env = {
    npmDeps = fetchNpmDeps {
      src = "${finalAttrs.src}/frontend";
      hash = "sha256-uxWpVL5ynuNu2PtPqgyvoCo7CMRbXSHKVlx/VVVfS3Q=";
    };
    npmRoot = "frontend";
  };

  desktopItems = [ "${finalAttrs.src}/flatpak/io.scottlabs.reManager.desktop" ];

  # Build GUI in postBuild so it doesn't affect buildGoModule's buildPhase for the CLI
  postBuild = ''
    wails build -m -trimpath \
      -tags webkit2_41 \
      -ldflags "${lib.concatStringsSep " " finalAttrs.ldflags}" \
      -o reManager
  '';
  # Ditto for postInstall
  postInstall = ''
    install -Dm 0755 build/bin/reManager $out/bin/reManager
    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp assets/icon.svg $out/share/icons/hicolor/scalable/apps/io.scottlabs.reManager.svg
  '';

  meta = {
    description = "Desktop app for managing mods on reMarkable tablets";
    homepage = "https://remanager.io";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ Mop-u ];
    platforms = [ "x86_64-linux" ];
  };
})
