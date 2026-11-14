{
  lib,
  rustPlatform,
  fetchFromGitHub,

  # nativeBuildInputs
  pkg-config,
  wrapGAppsHook3,

  # buildInputs
  gtk3,

  # rpath
  libGL,
  libx11,
  libxcursor,
  libxi,
  libxkbcommon,
  libxrandr,
  vulkan-loader,
  wayland,

  # tests
  dejavu_fonts,
  makeFontsConf,

  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dbml-ui";
  version = "0.2.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "BoilingSoup";
    repo = "DBML-UI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j4O8xOihcRPENn5xM2EkYORvE7O053nJy9UqXl8IVps=";
  };

  cargoHash = "sha256-ae5n7OUVtO7iHL3/ApDsLTiIChBcdjEeblCr50VoytQ=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  # rfd's native file dialogs link GTK3
  buildInputs = [ gtk3 ];

  # the raster tests render SVG text through resvg's system font database,
  # which resolves no family in the sandbox without a fontconfig file
  preCheck = ''
    export FONTCONFIG_FILE=${makeFontsConf { fontDirectories = [ dejavu_fonts ]; }}
  '';

  postInstall = ''
    install -Dm644 packaging/flatpak/io.github.boilingsoup.dbmlui.desktop \
      -t $out/share/applications
    install -Dm644 packaging/flatpak/io.github.boilingsoup.dbmlui.metainfo.xml \
      -t $out/share/metainfo
    for size in 16 32 48 64 128 256 512; do
      install -Dm644 icons/app-icon-$size.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/io.github.boilingsoup.dbmlui.png
    done
  '';

  # wrapGAppsHook3 wraps during fixupOutputHooks, i.e. before postFixup, which
  # would leave patchelf adding the rpath to the wrapper instead of the binary
  dontWrapGApps = true;

  # winit and wgpu dlopen the windowing and GPU libraries, so the rpath has to
  # be added after fixupPhase shrinks it
  postFixup = ''
    patchelf $out/bin/dbml-ui \
      --add-rpath ${
        lib.makeLibraryPath [
          libGL
          libx11
          libxcursor
          libxi
          libxkbcommon
          libxrandr
          vulkan-loader
          wayland
        ]
      }

    wrapProgram $out/bin/dbml-ui "''${gappsWrapperArgs[@]}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Database schema diagram editor built on DBML";
    longDescription = ''
      A native desktop editor for DBML database schemas: edit DBML on the
      left and watch the entity-relationship diagram render live on the
      right. Diagrams export as SVG or PNG, schemas export as SQL DDL for
      PostgreSQL, MySQL, SQL Server, Oracle and SQLite, and SQL dumps can be
      imported back with the dialect detected from the dump.
    '';
    homepage = "https://github.com/BoilingSoup/DBML-UI";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ redhawk ];
    mainProgram = "dbml-ui";
    platforms = lib.platforms.linux;
  };
})
