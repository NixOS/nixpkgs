{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  makeWrapper,
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
  withHeif ? true,
  defaultToXWayland ? false,
  xwayland ? null,
}:

let
  pname = "lightcraft";
  version = "0.6.0";
  commit = "9e6c4c6fc9c7a7f192ce846c00ceb531e0f64dda";
  buildDate = "2026-10-10";

  craftFonts = fetchFromGitHub {
    owner = "storytold";
    repo = "craft-fonts";
    rev = "8dcdacd5153e64560d109541a47d806f26f048c0";
    hash = "sha256-4E9OrthE5z39xFXpvpwn4Fn6RH3wX2sF56rZZejZT+I=";
  };

  runtimeLibs = lib.optionals stdenv.hostPlatform.isLinux [
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
    "lightcraft"
    "-p"
    "lightcraft-cli"
  ];
in
rustPlatform.buildRustPackage {
  inherit pname version;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "lightcraft";
    rev = "v${version}";
    hash = "sha256-hPRTJQql7TzmqZgkmDU1W3/IQMLQD/XzHNi6Lyv4XE0=";
  };

  cargoHash = "sha256-UyQP8+z8gd5g0uoeGK6C8O0uw318vJ1l/IZ7ShTdcek=";

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

  buildFeatures = lib.optionals withHeif [
    "lightcraft/heif"
    "lightcraft-cli/heif"
  ];

  env =
    lib.optionalAttrs withCraftFonts {
      CRAFT_FONTS_DIR = "${craftFonts}";
      CRAFT_FONTS_REQUIRED = "1";
    }
    // {
      LIGHTCRAFT_BUILD_SHA = commit;
      LIGHTCRAFT_BUILD_DATE = buildDate;
    };

  postInstall = ''
    install -Dm644 packaging/linux/ai.storyteller.lightcraft.desktop $out/share/applications/ai.storyteller.lightcraft.desktop
    install -Dm644 packaging/linux/ai.storyteller.lightcraft.mime.xml $out/share/mime/packages/ai.storyteller.lightcraft.xml

    mkdir -p $out/share/metainfo
    substitute packaging/linux/ai.storyteller.lightcraft.metainfo.xml.in $out/share/metainfo/ai.storyteller.lightcraft.metainfo.xml \
      --subst-var-by VERSION "${version}" \
      --subst-var-by DATE "${buildDate}"

    mkdir -p $out/share/icons
    cp -r assets/app-icon/hicolor $out/share/icons/

    mkdir -p $out/share/doc/lightcraft
    for f in README.md LICENSE LICENSE-MIT LICENSE-APACHE NOTICE; do
      if [ -f "$f" ]; then
        install -Dm644 "$f" "$out/share/doc/lightcraft/$f"
      fi
    done
    if [ -f "assets/ATTRIBUTION.md" ]; then
      install -Dm644 assets/ATTRIBUTION.md "$out/share/doc/lightcraft/ATTRIBUTION.md"
    fi
    if [ -f "assets/fonts/OFL-Inter.txt" ]; then
      install -Dm644 assets/fonts/OFL-Inter.txt "$out/share/doc/lightcraft/OFL-Inter.txt"
    fi
  ''
  + lib.optionalString withCraftFonts ''
    for lic in ${craftFonts}/fonts/*/OFL.txt; do
      if [ -f "$lic" ]; then
        fam=$(basename $(dirname "$lic"))
        install -Dm644 "$lic" "$out/share/doc/lightcraft/OFL-$fam.txt"
      fi
    done
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
        wrapProgram $out/bin/lightcraft \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
          ${
            lib.optionalString (xwayland != null) "--prefix PATH : \"${lib.makeBinPath [ xwayland ]}\""
          } \
          ${lib.optionalString defaultToXWayland "--unset WAYLAND_DISPLAY --unset WAYLAND_SOCKET"}

        wrapProgram $out/bin/lightcraft-cli \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}"

        makeWrapper $out/bin/.lightcraft-wrapped $out/bin/lightcraft-xwayland \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
          ${
            lib.optionalString (xwayland != null) "--prefix PATH : \"${lib.makeBinPath [ xwayland ]}\""
          } \
          --unset WAYLAND_DISPLAY \
          --unset WAYLAND_SOCKET

        makeWrapper $out/bin/.lightcraft-wrapped $out/bin/lightcraft-wayland \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
          ${lib.optionalString (xwayland != null) "--prefix PATH : \"${lib.makeBinPath [ xwayland ]}\""}

        cat >> $out/share/applications/ai.storyteller.lightcraft.desktop <<EOF

    Actions=XWayland;Wayland;

    [Desktop Action XWayland]
    Name=Open under XWayland (Drag and Drop support)
    Exec=lightcraft-xwayland %F

    [Desktop Action Wayland]
    Name=Open under native Wayland
    Exec=lightcraft-wayland %F
    EOF
  '';

  meta = with lib; {
    description = "Photo library and non-destructive raw developer";
    homepage = "https://github.com/storytold/lightcraft";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ johnrizzo1 ];
    mainProgram = "lightcraft";
    platforms = platforms.unix;
  };
}
