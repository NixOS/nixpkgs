{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  copyDesktopItems,
  gtk3,
  libayatana-appindicator,
  libxkbcommon,
  vulkan-loader,
  wayland,
  libx11,
  libxcursor,
  libxi,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "impactor";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "claration";
    repo = "Impactor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yFdLgUyh5qEEV+m0sNTgmevVMzaNbgYU/v5YdXZePk4=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-cLq1W8yqwKvyUksOlI8Gkt36zu1i7MYJzLcxXvyAjsU=";
  cargoBuildFlags = [
    "--package=plumeimpactor"
    "--package=plumesign"
  ];

  # The only tests in the workspace live in the vendored forks under
  # `3rdparty/` and require network access.
  doCheck = false;

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    gtk3

    libx11
    libxcursor
    libxi
  ];
  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
  ];

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    "${finalAttrs.src}/package/linux/dev.khcrysalis.PlumeImpactor.desktop"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/share
    cp -r package/linux/icons $out/share/
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf $out/bin/plumeimpactor \
      --add-rpath ${
        lib.makeLibraryPath [
          vulkan-loader
          wayland
          libxkbcommon
          libayatana-appindicator
        ]
      }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Feature-rich iOS/tvOS sideloading application";
    homepage = "https://impactor.claration.dev";
    changelog = "https://github.com/claration/Impactor/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      mit
      bsd3
    ];
    maintainers = with lib.maintainers; [ tuhana ];
    mainProgram = "plumeimpactor";
  };
})
