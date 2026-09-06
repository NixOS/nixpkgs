{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  makeWrapper,
  libx11,
  libxcursor,
  libGL,
  alsa-lib,
  vulkan-loader,
  vulkan-validation-layers,
  vulkan-tools,
  makeDesktopItem,
  copyDesktopItems,
  zig_0_16,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.3.0";
  pname = "cubyz";
  src = fetchFromGitHub {
    owner = "pixelguys";
    repo = "cubyz";
    tag = finalAttrs.version;
    hash = "sha256-dqxtASlOGWqSXXKIsCYnNyLz1WFJ7qYHhnMe0blWjLc=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  cubAssets = fetchFromGitHub {
    owner = "PixelGuys";
    repo = "Cubyz-Assets";
    tag = "0.3.5";
    hash = "sha256-rTisqHPvVvZmmsG44Z+860keaDu+cS3lLRBNm+uYT0w=";
  };

  zigDeps = zig_0_16.fetchDeps {
    inherit (finalAttrs) src pname version;
    fetchAll = true;
    hash = "sha256-bp+fhqp33q/xqPZgpiIenmKIF0ivTCMlV5JPQVnSxhI=";
  };

  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  preBuild = "
    mkdir -p ../Cubyz-libs/zig-out
    ln -s ${callPackage ./libs.nix { }}/* ../Cubyz-libs/zig-out/
  ";

  nativeBuildInputs = [
    zig_0_16.hook
    makeWrapper # Needed for env variables
    copyDesktopItems
  ];

  buildInputs = [
    libx11
    libGL
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools
    libxcursor
    alsa-lib
  ];

  zigBuildFlags = [
    "-Doptimize=ReleaseSafe"
  ];

  postBuild = ''
    mkdir -p $out/assets/cubyz
    cp -r $cubAssets/* $out/assets/cubyz/.
    cp -r $src/assets/cubyz/* $out/assets/cubyz/.

    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp -r $src/assets/cubyz/logo.png $out/share/icons/hicolor/256x256/apps/cubyz.png

    cat <<'EOF' > $out/launchConfig.zon
    .{
      .cubyzDir = "",
      .autoEnterWorld = "",
      .headlessServer = false,
    }
    EOF
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "cubyz";
      desktopName = "Cubyz";
      comment = finalAttrs.meta.description;
      exec = "Cubyz";
      icon = "cubyz";
      categories = [ "Game" ];
    })
  ];

  postInstall = ''
    wrapProgram $out/bin/Cubyz \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}" \
      --prefix VK_LAYER_PATH : "${vulkan-validation-layers}/share/vulkan/explicit_layer.d" \
      --run "
        cd $out/.
      "
  '';

  meta = {
    homepage = "https://github.com/PixelGuys/Cubyz";
    description = "Voxel sandbox game with a large render distance, procedurally generated content and some cool graphical effects";
    changelog = "https://github.com/PixelGuys/Cubyz/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    broken = stdenv.hostPlatform.isAarch64;
    mainProgram = "cubyz";
    maintainers = with lib.maintainers; [ leha44581 ];
  };
})
