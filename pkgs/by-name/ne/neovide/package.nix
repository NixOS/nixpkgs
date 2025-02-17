{
  lib,
  rustPlatform,
  clangStdenv,
  fetchFromGitHub,
  linkFarm,
  fetchgit,
  runCommand,
  gn,
  neovim,
  ninja,
  makeWrapper,
  pkg-config,
  python3,
  removeReferencesTo,
  cctools,
  SDL2,
  fontconfig,
  xorg,
  stdenv,
  libglvnd,
  libxkbcommon,
  enableWayland ? stdenv.hostPlatform.isLinux,
  wayland,
}:

rustPlatform.buildRustPackage.override { stdenv = clangStdenv; } rec {
  pname = "neovide";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "neovide";
    repo = "neovide";
    rev = version;
    hash = "sha256-4fdC/wChsCICLd69ZjK7IaCH7gDmXvfKllCnRNsdqYI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-k3eblWIlOaGJHUSgxxsU2aFR504M+8XTXP16kt2fXbY=";

  SKIA_SOURCE_DIR =
    let
      repo = fetchFromGitHub {
        owner = "rust-skia";
        repo = "skia";
        # see rust-skia:skia-bindings/Cargo.toml#package.metadata skia
        rev = "m131-0.79.1";
        hash = "sha256-XqXfKNYSiECbN96WVWA67Vy4sPuVvg6KqHESjA8gFJM=";
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

  SKIA_GN_COMMAND = "${gn}/bin/gn";
  SKIA_NINJA_COMMAND = "${ninja}/bin/ninja";

  nativeBuildInputs =
    [
      makeWrapper
      pkg-config
      python3 # skia
      removeReferencesTo
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      cctools.libtool
    ];

  nativeCheckInputs = [ neovim ];

  buildInputs = [
    SDL2
    fontconfig
    rustPlatform.bindgenHook
  ];

  postFixup =
    let
      libPath = lib.makeLibraryPath (
        [
          libglvnd
          libxkbcommon
          xorg.libXcursor
          xorg.libXext
          xorg.libXrandr
          xorg.libXi
        ]
        ++ lib.optionals enableWayland [ wayland ]
      );
    in
    ''
      # library skia embeds the path to its sources
      remove-references-to -t "$SKIA_SOURCE_DIR" \
        $out/bin/neovide

      wrapProgram $out/bin/neovide \
        --prefix LD_LIBRARY_PATH : ${libPath}
    '';

  postInstall =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      cp -r extra/osx/Neovide.app $out/Applications
      ln -s $out/bin $out/Applications/Neovide.app/Contents/MacOS
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      for n in 16x16 32x32 48x48 256x256; do
        install -m444 -D "assets/neovide-$n.png" \
          "$out/share/icons/hicolor/$n/apps/neovide.png"
      done
      install -m444 -Dt $out/share/icons/hicolor/scalable/apps assets/neovide.svg
      install -m444 -Dt $out/share/applications assets/neovide.desktop
    '';

  disallowedReferences = [ SKIA_SOURCE_DIR ];

  meta = {
    description = "Neovide is a simple, no-nonsense, cross-platform graphical user interface for Neovim";
    mainProgram = "neovide";
    homepage = "https://neovide.dev/";
    changelog = "https://github.com/neovide/neovide/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ ck3d ];
    platforms = lib.platforms.unix;
  };
}
