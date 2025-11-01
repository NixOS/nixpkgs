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
  zig,
}:

let
  # This is kinda atrocious, but it works
  # Override default zig flags
  zig_hook =
    (zig.overrideAttrs {
      version = "0.15.0";
      src = fetchFromGitHub {
        owner = "ziglang";
        repo = "zig";
        rev = "bd97b66186dabb3533df1ea9eb650d7574496a59";
        hash = "sha256-EVIg01kQ3JCZxnnrk6qMJn3Gm3+BZzPs75x9Q+sxqBw=";
      };
    }).hook.overrideAttrs
      {
        zig_default_flags = "";
      };
in

stdenv.mkDerivation (finalAttrs: {
  version = "0.0.0";
  pname = "cubyz";
  src = fetchFromGitHub {
    owner = "pixelguys";
    repo = "cubyz";
    tag = finalAttrs.version;
    hash = "sha256-8dceQWoTUJHkClKiFH573gvi94SmTSiSl42Rh9+sPoE=";
  };

  postPatch = ''
    ln -s ${callPackage ./deps.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  preBuild = "
    mkdir -p ../Cubyz-libs/zig-out
    ln -s ${callPackage ./libs.nix { }}/* ../Cubyz-libs/zig-out/
  ";

  nativeBuildInputs = [
    zig_hook # Needed for building zig stuff
    makeWrapper # Needed for env variables
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
    #"-j6"				# Included in zig default flags
    "-Dcpu=baseline" # Included in zig default flags
    "-Drelease"
    "-Dlocal" # Use local libraries
    "-Doptimize=ReleaseSafe"
  ];

  # Symlink the assets to $out, add a desktop entry
  postBuild = ''
    mkdir -p $out/assets/cubyz
    ln -s ${callPackage ./assets.nix { }}/* $out/assets/cubyz/
    ln -s $src/assets/cubyz/* $out/assets/cubyz/

    printf "
      [Desktop Entry]
      Name=Cubyz
      Exec=$out/bin/Cubyz
      Icon=$out/assets/cubyz/logo.png
      Type=Application
      Categories=Game;
    " > $out/cubyz.desktop
  '';

  # Change some env variables, move a bunch of stuff under .config for modding purposes, symlink a desktop entry
  postInstall = ''
    wrapProgram $out/bin/Cubyz \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}" \
      --prefix VK_LAYER_PATH : "${vulkan-validation-layers}/share/vulkan/explicit_layer.d" \
      --run "
        cd \$HOME/.config/cubyz
        mkdir -p \$HOME/.config/cubyz/logs
        mkdir -p \$HOME/.config/cubyz/assets
        [ ! -d \$HOME/.config/cubyz/assets/cubyz ] && cp -pr $out/assets/cubyz \$HOME/.config/cubyz/assets/

        [ ! -f \$HOME/.config/cubyz/launchConfig.zon ] && printf \".{
          .cubyzDir = \\\"\$HOME/.config/cubyz\\\",
        }\" > \$HOME/.config/cubyz/launchConfig.zon

        [ ! -l \$HOME/.local/share/applications/cubyz.desktop ] && ln -sf $out/cubyz.desktop \$HOME/.local/share/applications/cubyz.desktop
      "
  '';

  meta = {
    homepage = "https://github.com/PixelGuys/Cubyz";
    description = "Voxel sandbox game with a large render distance, procedurally generated content and some cool graphical effects";
    changelog = "https://github.com/PixelGuys/Cubyz/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "cubyz";
    maintainers = with lib.maintainers; [ leha44581 ];
  };
})
