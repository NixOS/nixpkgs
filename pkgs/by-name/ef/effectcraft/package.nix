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
  defaultToXWayland ? false,
  xwayland ? null,
}:

let
  pname = "effectcraft";
  version = "0.8.0";
  commit = "f953cd2855bf36beffa6a4d608e9bf4b226e9442";
  buildDate = "2026-10-10";

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
    "effectcraft"
    "-p"
    "effectcraft-cli"
  ];
in
rustPlatform.buildRustPackage {
  inherit pname version;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "effectcraft";
    rev = "v${version}";
    hash = "sha256-3AXfnxlerTqw/5QLClauTvlpEXpXwksuLfzpe96HAoA=";
  };

  cargoHash = "sha256-WJo1nqiP1uQA5hXs1jaLO0CmyxZ1oqEOQ90N9BEsxSc=";

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

  env = {
    EFFECTCRAFT_BUILD_SHA = commit;
    EFFECTCRAFT_BUILD_DATE = buildDate;
  };

  postInstall = ''
    install -Dm644 packaging/linux/ai.storyteller.effectcraft.desktop $out/share/applications/ai.storyteller.effectcraft.desktop
    install -Dm644 packaging/linux/ai.storyteller.effectcraft.mime.xml $out/share/mime/packages/ai.storyteller.effectcraft.xml

    mkdir -p $out/share/metainfo
    sed -e "s/@VERSION@/${version}/g" -e "s/@DATE@/${buildDate}/g" \
      packaging/linux/ai.storyteller.effectcraft.metainfo.xml.in > $out/share/metainfo/ai.storyteller.effectcraft.metainfo.xml

    mkdir -p $out/share/icons
    cp -r assets/app-icon/hicolor $out/share/icons/

    mkdir -p $out/share/doc/effectcraft
    for f in README.md LICENSE LICENSE-MIT LICENSE-APACHE COPYRIGHT NOTICE ATTRIBUTION.md; do
      if [ -f "$f" ]; then
        install -Dm644 "$f" "$out/share/doc/effectcraft/$f"
      fi
    done
    for f in assets/fonts/OFL-*.txt; do
      if [ -f "$f" ]; then
        install -Dm644 "$f" "$out/share/doc/effectcraft/$(basename "$f")"
      fi
    done
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
        wrapProgram $out/bin/effectcraft \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
          ${
            lib.optionalString (xwayland != null) "--prefix PATH : \"${lib.makeBinPath [ xwayland ]}\""
          } \
          ${lib.optionalString defaultToXWayland "--unset WAYLAND_DISPLAY --unset WAYLAND_SOCKET"}

        wrapProgram $out/bin/effectcraft-cli \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}"

        makeWrapper $out/bin/.effectcraft-wrapped $out/bin/effectcraft-xwayland \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
          ${
            lib.optionalString (xwayland != null) "--prefix PATH : \"${lib.makeBinPath [ xwayland ]}\""
          } \
          --unset WAYLAND_DISPLAY \
          --unset WAYLAND_SOCKET

        makeWrapper $out/bin/.effectcraft-wrapped $out/bin/effectcraft-wayland \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
          ${lib.optionalString (xwayland != null) "--prefix PATH : \"${lib.makeBinPath [ xwayland ]}\""}

        cat >> $out/share/applications/ai.storyteller.effectcraft.desktop <<EOF

    Actions=XWayland;Wayland;

    [Desktop Action XWayland]
    Name=Open under XWayland (Drag and Drop support)
    Exec=effectcraft-xwayland %F

    [Desktop Action Wayland]
    Name=Open under native Wayland
    Exec=effectcraft-wayland %F
    EOF
  '';

  meta = with lib; {
    description = "Clean-room motion graphics and visual effects compositor in Rust";
    homepage = "https://github.com/storytold/effectcraft";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ johnrizzo1 ];
    mainProgram = "effectcraft";
    platforms = platforms.unix;
  };
}
