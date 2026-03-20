{
  autoPatchelfHook,
  fetchFromGitHub,
  fontconfig,
  freetype,
  lib,
  libgcc,
  libgit2,
  libx11,
  libxcb,
  libxkbcommon,
  nix-update-script,
  pkg-config,
  rustPlatform,
  stdenvNoCC,
  versionCheckHook,
  vulkan-loader,
  wayland,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitcomet";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "Auto-Explore";
    repo = "GitComet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GXQC+MA3af8+KhC/cMVHi/gNakwq1ejlTVGIn13M96c=";
  };

  cargoHash = "sha256-UUxsfdrGLIFg3bF8y53eQGO61aOXPlSyJoyzHdNJAPA=";

  nativeBuildInputs = [
    autoPatchelfHook
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    fontconfig
    freetype
    libgcc
    libgit2
    libxkbcommon
    zlib
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [
    libx11
    libxcb
  ];

  runtimeDependencies = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    vulkan-loader
    wayland
  ];

  postInstall = ''
    install -Dm644 assets/linux/gitcomet.desktop \
      --target-directory="$out"/share/applications

    for size in 32 48 128 256 512; do
      install -Dm644 assets/linux/hicolor/"$size"x"$size"/apps/gitcomet.png \
        --target-directory="$out"/share/icons/hicolor/"$size"x"$size"/apps
    done
  '';

  # https://github.com/Auto-Explore/GitComet/issues/57
  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fastest Git GUI";
    longDescription = ''
      GitComet is built for teams that want fast Git operations with
      local-first privacy, familiar workflows, and open source
      freedom.
    '';
    homepage = "https://gitcomet.dev";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "gitcomet";
  };
})
