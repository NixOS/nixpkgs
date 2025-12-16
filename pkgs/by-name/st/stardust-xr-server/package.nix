{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  alsa-lib,
  kdePackages,
  pkg-config,
  stereokit,
  openxr-loader,
  vulkan-loader,
  vulkan-headers,
  libxkbcommon,
}:

rustPlatform.buildRustPackage rec {
  pname = "stardust-xr-server";
  version = "0.45.1";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "server";
    rev = "4c4c9013702c470cb9e6062a4104364c6de3e110";
    hash = "sha256-xoIqzdjbqP9vsmNKxebkHZifN/287NMU3WoppPouCQk=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "bevy-dmabuf-0.2.0" = "sha256-9wM7XMD6N81+XUqR/Bn8nzY30/KzoqmEpX1qEGqB0bQ=";
      "bevy-equirect-0.1.1" = "sha256-mJhZqgN77op7YA4bL8VA6VqJ6vW3JDjj8Lan8hKRkXQ=";
      "bevy-mesh-text-3d-0.1.0" = "sha256-XEchikiYcT6/Uea9anxUvDDaeXpUlp8cI43nv5yNI70=";
      "bevy_core_pipeline-0.16.1" = "sha256-37cWKhlKmUf3aFGdJK/xjOg6A+dgM19tFsszdUkvwrw=";
      "bevy_gltf-0.16.1" = "sha256-0A1CePquZkVUcRu7zsAms8ZLJGIvzi3o9QyUT4SBJGQ=";
      "bevy_mod_openxr-0.3.0" = "sha256-uCpug+H7zdQn7xWDYNXq0m74+m2BevNaY/wJDir6mho=";
      "bevy_render-0.16.1" = "sha256-xlJU5I4TgysljV6zrQIbw5CQFcsX+UGX53OJgP7os6I=";
      "bevy_sk-0.1.0" = "sha256-ikWbF62E1x9pM3lNUpxTS0lT+B/k7fTaIw0vkLOeIJc=";
      "naga-24.0.0" = "sha256-HSGEJ5EChR6ndGsl+6s1Yz8J7Hs0mt2qzKPkx0XYWq0=";
      "stardust-xr-gluon-2.0.0" = "sha256-MsNTEdlj12TaxDprkbtjqEGfKunwcPsbuaUAsytYyf0=`";
      "stereokit-macros-0.5.1" = "sha256-IRVyrwvCwO72Q+s/dYMwGOnz9FYObXIinL+Y1hkszug=";
      "vulkano-0.35.1" = "sha256-ElXCDpy41Qe3m0zIDxUKN8KfW3MCdr3qTI9HgfMaxHw=";
      "waynest-0.1.0" = "sha256-ZvmjCEe3Ta8HNLtxtzX/YFAg9i6vVA2/7qozN8mD+jc=";
    };
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    kdePackages.wayland
    stereokit
    openxr-loader
    vulkan-loader
    vulkan-headers
  ];

  # TODO: Why is this necessary? I know it has something to do with bevy
  # https://github.com/bevyengine/bevy/blob/6002f6722d25e5cf940d6a56bc3a8de2d9c39bfa/crates/bevy_render/src/renderer/mod.rs
  # https://github.com/bevyengine/bevy/blob/6002f6722d25e5cf940d6a56bc3a8de2d9c39bfa/docs/linux_dependencies.md
  postFixup = ''
    patchelf $out/bin/stardust-xr-server --add-rpath ${vulkan-loader}/lib
    patchelf $out/bin/stardust-xr-server --add-rpath ${openxr-loader}/lib
    patchelf $out/bin/stardust-xr-server --add-rpath ${libxkbcommon}/lib
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wayland compositor and display server for 3D applications";
    homepage = "https://stardustxr.org/";
    changelog = "https://github.com/StardustXR/server/releases";
    license = lib.licenses.gpl2Plus;
    mainProgram = "stardust-xr-server";
    maintainers = lib.teams.stardust-xr.members;
    platforms = lib.platforms.unix;
  };
}
