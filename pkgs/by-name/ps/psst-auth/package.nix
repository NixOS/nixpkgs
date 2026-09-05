{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  patchelf,
  fontconfig,
  freetype,
  libxkbcommon,
  vulkan-loader,
  systemdLibs,
  stdenv,
  wayland,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "psst-auth";
  version = "0.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "phisch";
    repo = "psst";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yZ0oHKQ4VEZRXxNCVFIumKMT/wIfGt+o/gwubk8u4sU=";
  };

  cargoHash = "sha256-H1mmA9x8iXib18+7JJt+AB1SEogbkmGA7HzX0AytXOE=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    patchelf
  ];

  buildInputs =
    [
      fontconfig
      freetype
      libxkbcommon
      vulkan-loader
      systemdLibs
      wayland
    ];

  postFixup = ''
    libPath="${lib.makeLibraryPath finalAttrs.buildInputs}"
    for bin in $out/bin/*; do
      patchelf --set-rpath "$libPath" "$bin"
    done
  '';

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "Beautiful (and themeable), unified UI for your pinentry, GNOME keyring-prompter and polkit-agent";
    homepage = "https://github.com/phisch/psst";
    changelog = "https://github.com/phisch/psst/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      gpl3Only
      mpl20
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ araucaria223 ];
  };
})
