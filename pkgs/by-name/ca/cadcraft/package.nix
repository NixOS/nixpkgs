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
  defaultToXWayland ? false,
  xwayland ? null,
}:

let
  pname = "cadcraft";
  version = "0.5.0";
  commit = "315751e3ec98e708bcc831dd7f80ca0433a2e3d0";
  buildDate = "2026-10-10";

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
    "cadcraft"
    "-p"
    "cadcraft-cli"
  ];
in
rustPlatform.buildRustPackage {
  inherit pname version;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "cadcraft";
    rev = "v${version}";
    hash = "sha256-TD7qh64rwYZOymru3EoRuuBGJJRZ75xE1WJC+Mq8RhQ=";
  };

  cargoHash = "sha256-Y8bqSY/ok6gmH/V4C0AL0j4CDMxEIXkYdm/VBHuB4UI=";

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
    CADCRAFT_BUILD_SHA = commit;
    CADCRAFT_BUILD_DATE = buildDate;
  };

  postInstall = ''
    install -Dm644 packaging/linux/ai.storyteller.cadcraft.desktop $out/share/applications/ai.storyteller.cadcraft.desktop
    install -Dm644 packaging/linux/ai.storyteller.cadcraft.mime.xml $out/share/mime/packages/ai.storyteller.cadcraft.xml

    mkdir -p $out/share/metainfo
    sed -e "s/@VERSION@/${version}/g" -e "s/@DATE@/${buildDate}/g" \
      packaging/linux/ai.storyteller.cadcraft.metainfo.xml.in > $out/share/metainfo/ai.storyteller.cadcraft.metainfo.xml

    mkdir -p $out/share/icons
    cp -r assets/app-icon/hicolor $out/share/icons/

    mkdir -p $out/share/doc/cadcraft
    for f in README.md LICENSE LICENSE-MIT LICENSE-APACHE COPYRIGHT NOTICE ATTRIBUTION.md; do
      if [ -f "$f" ]; then
        install -Dm644 "$f" "$out/share/doc/cadcraft/$f"
      fi
    done
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
        wrapProgram $out/bin/cadcraft \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
          ${
            lib.optionalString (xwayland != null) "--prefix PATH : \"${lib.makeBinPath [ xwayland ]}\""
          } \
          ${lib.optionalString defaultToXWayland "--unset WAYLAND_DISPLAY --unset WAYLAND_SOCKET"}

        wrapProgram $out/bin/cadcraft-cli \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}"

        makeWrapper $out/bin/.cadcraft-wrapped $out/bin/cadcraft-xwayland \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
          ${
            lib.optionalString (xwayland != null) "--prefix PATH : \"${lib.makeBinPath [ xwayland ]}\""
          } \
          --unset WAYLAND_DISPLAY \
          --unset WAYLAND_SOCKET

        makeWrapper $out/bin/.cadcraft-wrapped $out/bin/cadcraft-wayland \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
          ${lib.optionalString (xwayland != null) "--prefix PATH : \"${lib.makeBinPath [ xwayland ]}\""}

        cat >> $out/share/applications/ai.storyteller.cadcraft.desktop <<EOF

    Actions=XWayland;Wayland;

    [Desktop Action XWayland]
    Name=Open under XWayland (Drag and Drop support)
    Exec=cadcraft-xwayland %F

    [Desktop Action Wayland]
    Name=Open under native Wayland
    Exec=cadcraft-wayland %F
    EOF
  '';

  meta = with lib; {
    description = "Clean-room computer-aided design (CAD) workbench in pure Rust";
    homepage = "https://github.com/storytold/cadcraft";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ johnrizzo1 ];
    mainProgram = "cadcraft";
    platforms = platforms.unix;
  };
}
