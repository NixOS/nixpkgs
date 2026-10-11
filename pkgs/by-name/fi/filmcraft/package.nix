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
  withWhisper ? false,
  withNeuralVoices ? false,
  defaultToXWayland ? false,
  xwayland ? null,
}:

let
  pname = "filmcraft";
  version = "0.6.0";
  commit = "2ff3f5e266838700c292a35aaf762e3d4dcef980";
  buildDate = "2026-10-10";

  craftFonts = fetchFromGitHub {
    owner = "storytold";
    repo = "craft-fonts";
    rev = "abb83316d96aa59c1cf64784289e378fe9fa5695";
    hash = "sha256-e+6HpOYoAFTh6mNfGBBw2njnBzcE8W8+Jybv1+dKOCA=";
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
    "filmcraft"
    "-p"
    "filmcraft-cli"
  ];
in
rustPlatform.buildRustPackage {
  inherit pname version;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "filmcraft";
    rev = "v${version}";
    hash = "sha256-aAKyxB3r3y1IEYyMjD2CJgD118kk8OdWeVCnvM5+v+0=";
  };

  cargoHash = "sha256-oJadymZHT/paCUvI9iXlUlST4SckUpdH6r5PCJkXbXI=";

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

  buildFeatures =
    lib.optionals withWhisper [
      "filmcraft/whisper"
      "filmcraft-cli/whisper"
    ]
    ++ lib.optionals withNeuralVoices [ "filmcraft/neural-voices" ];

  env =
    lib.optionalAttrs withCraftFonts {
      CRAFT_FONTS_DIR = "${craftFonts}";
      CRAFT_FONTS_REQUIRED = "1";
    }
    // {
      FILMCRAFT_BUILD_SHA = commit;
      FILMCRAFT_BUILD_DATE = buildDate;
    };

  postInstall = ''
    install -Dm644 packaging/linux/ai.storyteller.filmcraft.desktop $out/share/applications/ai.storyteller.filmcraft.desktop
    install -Dm644 packaging/linux/ai.storyteller.filmcraft.mime.xml $out/share/mime/packages/ai.storyteller.filmcraft.xml

    mkdir -p $out/share/metainfo
    substitute packaging/linux/ai.storyteller.filmcraft.metainfo.xml.in $out/share/metainfo/ai.storyteller.filmcraft.metainfo.xml \
      --subst-var-by VERSION "${version}" \
      --subst-var-by DATE "${buildDate}"

    mkdir -p $out/share/icons
    cp -r assets/app-icon/hicolor $out/share/icons/

    mkdir -p $out/share/doc/filmcraft
    for f in README.md LICENSE LICENSE-MIT LICENSE-APACHE COPYRIGHT NOTICE ATTRIBUTION.md; do
      if [ -f "$f" ]; then
        install -Dm644 "$f" "$out/share/doc/filmcraft/$f"
      fi
    done
    for f in assets/fonts/OFL-*.txt; do
      if [ -f "$f" ]; then
        install -Dm644 "$f" "$out/share/doc/filmcraft/$(basename "$f")"
      fi
    done
  ''
  + lib.optionalString withCraftFonts ''
    for lic in ${craftFonts}/fonts/*/OFL.txt; do
      if [ -f "$lic" ]; then
        fam=$(basename $(dirname "$lic"))
        install -Dm644 "$lic" "$out/share/doc/filmcraft/OFL-$fam.txt"
      fi
    done
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
        wrapProgram $out/bin/filmcraft \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
          ${
            lib.optionalString (xwayland != null) "--prefix PATH : \"${lib.makeBinPath [ xwayland ]}\""
          } \
          ${lib.optionalString defaultToXWayland "--unset WAYLAND_DISPLAY --unset WAYLAND_SOCKET"}

        wrapProgram $out/bin/filmcraft-cli \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}"

        makeWrapper $out/bin/.filmcraft-wrapped $out/bin/filmcraft-xwayland \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
          ${
            lib.optionalString (xwayland != null) "--prefix PATH : \"${lib.makeBinPath [ xwayland ]}\""
          } \
          --unset WAYLAND_DISPLAY \
          --unset WAYLAND_SOCKET

        makeWrapper $out/bin/.filmcraft-wrapped $out/bin/filmcraft-wayland \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
          ${lib.optionalString (xwayland != null) "--prefix PATH : \"${lib.makeBinPath [ xwayland ]}\""}

        cat >> $out/share/applications/ai.storyteller.filmcraft.desktop <<EOF

    Actions=XWayland;Wayland;

    [Desktop Action XWayland]
    Name=Open under XWayland (Drag and Drop support)
    Exec=filmcraft-xwayland %F

    [Desktop Action Wayland]
    Name=Open under native Wayland
    Exec=filmcraft-wayland %F
    EOF
  '';

  meta = with lib; {
    description = "Clean-room video editor, color grading and audio workstation in pure Rust";
    homepage = "https://github.com/storytold/filmcraft";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ johnrizzo1 ];
    mainProgram = "filmcraft";
    platforms = platforms.unix;
  };
}
