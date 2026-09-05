{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  oniguruma,
  vulkan-loader,
  zstd,
  stdenv,
  wayland,
  nix-update-script,
  withGui ? false,
}:

let
  rpathLibs = lib.optionals stdenv.hostPlatform.isLinux [
    wayland
    libxkbcommon
    vulkan-loader
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "cfait${lib.optionalString withGui "-gui"}";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "trougnouf";
    repo = "cfait";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8wbQdCWpyzOjawdp/78cKPiBixhLfU5OBUZvKW0i6yY=";
  };

  cargoHash = "sha256-wIMrfW2atR64xUd8li+dplK1qQW2tvA+Fim9kf+xAt4=";

  buildFeatures = lib.optionals withGui [ "gui" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    oniguruma
    zstd
  ]
  ++ rpathLibs;

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  postInstall = lib.optionalString withGui (
    lib.optionalString stdenv.hostPlatform.isLinux ''
      # patchelf generates an ELF that binutils' "strip" doesn't like:
      #    strip: not enough room for program headers, try linking with -N
      # As a workaround, strip manually before running patchelf.
      # $STRIP -S $out/bin/cfait-gui

      patchelf --add-rpath "${lib.makeLibraryPath rpathLibs}" $out/bin/cfait-gui
    ''
    + ''
      # Remove TUI binary from GUI package to keep them separate
      rm $out/bin/cfait
    ''
  );

  dontPatchELF = true;

  doCheck = false; # Some checks fail on NixOS

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Take control of your TODO list";
    homepage = "https://github.com/trougnouf/cfait";
    changelog = "https://github.com/trougnouf/cfait/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      ofl
      agpl3Only
      gpl3Only
    ];
    maintainers = with lib.maintainers; [ nemeott ];
    mainProgram = "cfait${lib.optionalString withGui "-gui"}";
    platforms = lib.platforms.unix;
  };
})
