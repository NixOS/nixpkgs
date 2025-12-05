{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  vulkan-loader,
  vulkan-headers,
  vulkan-memory-allocator,
  zlib,
  stdenv,
  clangStdenv,
  python3,
  wayland,
  cctools,
  gn,
  ninja,
  linkFarm,
  fetchgit,
  runCommand,
  fontconfig,
}:

rustPlatform.buildRustPackage.override { stdenv = clangStdenv; } (finalAttrs: {
  pname = "skia-canvas";
  version = "3.0.8";

  src = fetchFromGitHub {
    owner = "samizdatco";
    repo = "skia-canvas";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VOasEzXQ6VEd3vtqQ3NifLnozgV8MgjZx/2B9lQp3Ao=";
  };

  cargoHash = "sha256-Hj2m3+T0pcIDnpSog5t2648TUfqBaXJqE6YP+9sgalI=";

  # there are no checks
  doCheck = false;

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools.libtool
  ];

  buildInputs = [
    libxkbcommon
    vulkan-loader
    zlib
  ]
  ++ lib.optionals stdenv.isLinux [
    fontconfig
    wayland
    vulkan-headers
    vulkan-memory-allocator
  ];

  buildFeatures =
    lib.optionals stdenv.hostPlatform.isDarwin [
      "metal"
      "window"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      "vulkan"
      "window"
      "freetype"
    ];

  env = {
    SKIA_GN_COMMAND = "${gn}/bin/gn";
    SKIA_NINJA_COMMAND = "${ninja}/bin/ninja";
    SKIA_SOURCE_DIR =
      let
        repo = fetchFromGitHub {
          owner = "rust-skia";
          repo = "skia";
          # see rust-skia:skia-bindings/Cargo.toml#package.metadata skia
          tag = "m140-0.87.4";
          hash = "sha256-pHxqTrqguZcPmuZgv0ASbJ3dgn8JAyHI7+PdBX5gAZQ=";
        };
        # The externals for skia are taken from skia/DEPS
        externals = linkFarm "skia-externals" (
          lib.mapAttrsToList (name: value: {
            inherit name;
            path = fetchgit value;
          }) (lib.importJSON ./skia-externals.json)
        );
      in
      runCommand "source" { } ''
        cp -R ${repo} $out
        chmod -R +w $out
        ln -s ${externals} $out/third_party/externals
      '';
  };

  meta = {
    description = "A multi-threaded, GPU-powered, 2D vector graphics environment for Node.js";
    homepage = "https://github.com/samizdatco/skia-canvas";
    changelog = "https://github.com/samizdatco/skia-canvas/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xanderio ];
    mainProgram = "skia-canvas";
  };
})
