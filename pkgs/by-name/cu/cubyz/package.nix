{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchgit,
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
  llvmPackages,
}:

# This is kinda atrocious, but it works
let
  zig_hook =
    (
      (zig.override {
        llvmPackages = llvmPackages;
      }).overrideAttrs
      (oldAttrs: {
        version = "0.16.0";
        src = fetchgit {
          url = "https://codeberg.org/ziglang/zig";
          rev = "d3e20e71be8d94b8c0534d2cb57a1a27c451db9f";
          hash = "sha256-DKOQiB183AuWhkitPclFJqKBi9CTkK6Lccw1vLgF0OQ=";
        };

        nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [
          llvmPackages.llvm
          llvmPackages.lld
          llvmPackages.clang
        ];
      })
    ).hook.overrideAttrs
      {
        zig_default_flags = "";
      };
in

stdenv.mkDerivation (finalAttrs: {
  version = "0.1.1";
  pname = "cubyz";
  src = fetchFromGitHub {
    owner = "pixelguys";
    repo = "cubyz";
    tag = finalAttrs.version;
    hash = "sha256-i4AtZR++xnpbYOr1/defKW85Zj+u0Tgs4wZLZWZ2ST0=";
  };

  cubAssets = fetchFromGitHub {
    owner = "PixelGuys";
    repo = "Cubyz-Assets";
    rev = "e4bc38baffdeb9912280eefeebb7d40e8e95fa3f";
    hash = "sha256-uPHH5hWcw/HJ/AiXK+FsvQLycvTBJ1LIsnGOzF/KXlk=";
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
    #"-Dcpu=baseline" # Included in zig default flags
    "-Drelease"
    "-Dlocal" # Use local libraries
    "-Doptimize=ReleaseSafe"
  ];

  # Symlink the assets to $out, add a desktop entry
  postBuild = ''
    mkdir -p $out/assets/cubyz
    ln -s $cubAssets/* $out/assets/cubyz/.
    ln -s $src/assets/cubyz/* $out/assets/cubyz/.

    mkdir -p $out/share/applications
    printf "
      [Desktop Entry]
      Name=Cubyz
      Version=${finalAttrs.version}
      Comment=${finalAttrs.meta.description}
      Exec=$out/bin/Cubyz
      Icon=$out/assets/cubyz/logo.png
      Type=Application
      Categories=Game;
    " > $out/share/applications/cubyz.desktop
  '';

  # Change some env variables, move a bunch of stuff under .config for modding purposes
  postInstall = ''
    wrapProgram $out/bin/Cubyz \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}" \
      --prefix VK_LAYER_PATH : "${vulkan-validation-layers}/share/vulkan/explicit_layer.d" \
      --run "
        mkdir -p \$HOME/.config/cubyz/logs
        mkdir -p \$HOME/.config/cubyz/assets
        cd \$HOME/.config/cubyz
        [ ! -d \$HOME/.config/cubyz/assets/cubyz ] && cp -pr $out/assets/cubyz \$HOME/.config/cubyz/assets/

        [ ! -f \$HOME/.config/cubyz/launchConfig.zon ] && printf \".{
          .cubyzDir = \\\"\$HOME/.config/cubyz\\\",
        }\" > \$HOME/.config/cubyz/launchConfig.zon
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
