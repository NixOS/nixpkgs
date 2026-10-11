{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  makeWrapper,
  alsa-lib,
  fontconfig,
  libGL,
  libx11,
  libxcursor,
  libxi,
  libxrandr,
  libxcb,
  libxkbcommon,
  wayland,
  wayland-scanner ? null,
  vulkan-loader,
  autoAddDriverRunpath ? null,
  apple-sdk ? null,
  withCraftFonts ? true,
  defaultToXWayland ? false,
  xwayland ? null,
}:

let
  pname = "deckcraft";
  version = "0.5.0";
  commit = "a98df49b21632d69a3da994d35df1ea91dab41af";
  buildDate = "2026-10-10";

  craftFonts = fetchFromGitHub {
    owner = "storytold";
    repo = "craft-fonts";
    rev = "43913056ce82a3fdad0ef69f6b88d1dc922a8104";
    hash = "sha256-u1fC5spekizPXnrK6uiKEZSr2SJOaBF4ffLDbKkywEY=";
  };

  runtimeLibs = lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libGL
    vulkan-loader
    libxkbcommon
    wayland
    libx11
    libxcursor
    libxi
    libxrandr
    libxcb
    fontconfig
  ];

  workspacePackages = [
    "-p"
    "deckcraft"
    "-p"
    "deckcraft-cli"
  ];
in
rustPlatform.buildRustPackage {
  inherit pname version;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "deckcraft";
    rev = "v${version}";
    hash = "sha256-B+kuyp/5j/yKqaQgood7VL4Vhf0gnOSTqT43VYa1LwE=";
  };

  cargoHash = "sha256-5LjT/3EfDPguMPF4/TD6rpIefLk8+sIN0LD6Am3oDTQ=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux (
    lib.optional (wayland-scanner != null) wayland-scanner
    ++ lib.optional (autoAddDriverRunpath != null) autoAddDriverRunpath
  );

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux runtimeLibs
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk
    ];

  cargoBuildFlags = workspacePackages;
  cargoTestFlags = workspacePackages;

  env =
    lib.optionalAttrs withCraftFonts {
      CRAFT_FONTS_DIR = "${craftFonts}";
      CRAFT_FONTS_REQUIRED = "1";
    }
    // {
      DECKCRAFT_BUILD_SHA = commit;
      DECKCRAFT_BUILD_DATE = buildDate;
    };

  postInstall = ''
    install -Dm644 packaging/linux/ai.storyteller.deckcraft.desktop $out/share/applications/ai.storyteller.deckcraft.desktop
    install -Dm644 packaging/linux/ai.storyteller.deckcraft.mime.xml $out/share/mime/packages/ai.storyteller.deckcraft.xml

    mkdir -p $out/share/metainfo
    sed -e "s/@VERSION@/${version}/g" -e "s/@DATE@/${buildDate}/g" \
      packaging/linux/ai.storyteller.deckcraft.metainfo.xml.in > $out/share/metainfo/ai.storyteller.deckcraft.metainfo.xml

    mkdir -p $out/share/icons
    cp -r assets/app-icon/hicolor $out/share/icons/

    mkdir -p $out/share/doc/deckcraft
    for f in README.md LICENSE LICENSE-MIT LICENSE-APACHE COPYRIGHT NOTICE ATTRIBUTION.md; do
      if [ -f "$f" ]; then
        install -Dm644 "$f" "$out/share/doc/deckcraft/$f"
      fi
    done
  ''
  + lib.optionalString withCraftFonts ''
    for lic in ${craftFonts}/fonts/*/OFL.txt; do
      if [ -f "$lic" ]; then
        fam=$(basename $(dirname "$lic"))
        install -Dm644 "$lic" "$out/share/doc/deckcraft/OFL-$fam.txt"
      fi
    done
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
        wrapProgram $out/bin/deckcraft \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
          ${
            lib.optionalString (xwayland != null) "--prefix PATH : \"${lib.makeBinPath [ xwayland ]}\""
          } \
          ${lib.optionalString defaultToXWayland "--unset WAYLAND_DISPLAY --unset WAYLAND_SOCKET"}

        wrapProgram $out/bin/deckcraft-cli \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}"

        makeWrapper $out/bin/.deckcraft-wrapped $out/bin/deckcraft-xwayland \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
          ${
            lib.optionalString (xwayland != null) "--prefix PATH : \"${lib.makeBinPath [ xwayland ]}\""
          } \
          --unset WAYLAND_DISPLAY \
          --unset WAYLAND_SOCKET

        makeWrapper $out/bin/.deckcraft-wrapped $out/bin/deckcraft-wayland \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
          ${lib.optionalString (xwayland != null) "--prefix PATH : \"${lib.makeBinPath [ xwayland ]}\""}

        cat >> $out/share/applications/ai.storyteller.deckcraft.desktop <<EOF

    Actions=XWayland;Wayland;

    [Desktop Action XWayland]
    Name=Open under XWayland (Drag and Drop support)
    Exec=deckcraft-xwayland %F

    [Desktop Action Wayland]
    Name=Open under native Wayland
    Exec=deckcraft-wayland %F
    EOF
  '';

  meta = with lib; {
    description = "Clean-room presentation software to create and present slide decks in pure Rust";
    homepage = "https://github.com/storytold/deckcraft";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ johnrizzo1 ];
    mainProgram = "deckcraft";
    platforms = platforms.unix;
  };
}
