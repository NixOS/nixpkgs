{
  clangStdenv,
  rustPlatform,
  lib,
  linkFarm,
  fetchgit,
  fetchFromGitHub,
  runCommand,
  alsa-lib,
  brotli,
  cmake,
  expat,
  fontconfig,
  freetype,
  gn,
  harfbuzz,
  icu,
  libglvnd,
  libjpeg,
  libxkbcommon,
  libX11,
  libXcursor,
  libXext,
  libXi,
  libXrandr,
  makeWrapper,
  ninja,
  pkg-config,
  python3,
  removeReferencesTo,
  wayland,
  zlib,
}:

rustPlatform.buildRustPackage.override { stdenv = clangStdenv; } rec {
  pname = "chiptrack";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "jturcotte";
    repo = "chiptrack";
    rev = "refs/tags/v${version}";
    hash = "sha256-yQP5hFM5qBWdaF192PBvM4il6qpmlgUCeuwDCiw/LaQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    cmake
    makeWrapper
    pkg-config
    python3
    removeReferencesTo
  ];

  buildInputs = [
    expat
    fontconfig
    freetype
    harfbuzz
    icu
    libjpeg
  ] ++ lib.optionals clangStdenv.hostPlatform.isLinux [ alsa-lib ];

  # Has git dependencies
  useFetchCargoVendor = true;
  cargoHash = "sha256-3LRyAY5NmXiJRrN+jwaUX65ArBCl8BiFoaWU2fVRMA8=";

  env = {
    SKIA_SOURCE_DIR =
      let
        repo = fetchFromGitHub {
          owner = "rust-skia";
          repo = "skia";
          # see rust-skia:skia-bindings/Cargo.toml#package.metadata skia
          rev = "refs/tags/m129-0.77.1";
          hash = "sha256-WRVuQpfRnYrE7KGFRFx66fXtMFmtJbC3xUcRPK1JoOM=";
        };
        # The externals for skia are taken from skia/DEPS
        # Reduced to only what's necessary
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
    SKIA_GN_COMMAND = lib.getExe gn;
    SKIA_NINJA_COMMAND = lib.getExe ninja;
    SKIA_USE_SYSTEM_LIBRARIES = "1";

    NIX_CFLAGS_COMPILE = "-I${lib.getDev harfbuzz}/include/harfbuzz";
  };

  # library skia embeds the path to its sources
  postFixup = ''
    remove-references-to -t "$SKIA_SOURCE_DIR" \
      $out/bin/chiptrack

    wrapProgram $out/bin/chiptrack \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath (
          [
            brotli
            zlib
          ]
          ++ lib.optionals clangStdenv.hostPlatform.isLinux [
            libglvnd
            libxkbcommon
            libX11
            libXcursor
            libXext
            libXrandr
            libXi
            wayland
          ]
        )
      }
  '';

  disallowedReferences = [ env.SKIA_SOURCE_DIR ];

  meta = {
    description = "Programmable cross-platform sequencer for the Game Boy Advance sound chip";
    homepage = "https://github.com/jturcotte/chiptrack";
    license = with lib.licenses; [
      mit # main
      gpl3Only # GPL dependencies
    ];
    mainProgram = "chiptrack";
    maintainers = with lib.maintainers; [ OPNA2608 ];
    # Various issues with wrong max macOS version & misparsed target conditional checks, can't figure out the magic combination for this
    broken = clangStdenv.hostPlatform.isDarwin;
  };
}
