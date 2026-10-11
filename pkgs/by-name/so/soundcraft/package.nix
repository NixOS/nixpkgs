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
  pname = "soundcraft";
  version = "0.5.0";
  commit = "4410486fc21561a9db0dc33961a2017469127e0d";
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
    "soundcraft"
    "-p"
    "soundcraft-cli"
  ];
in
rustPlatform.buildRustPackage {
  inherit pname version;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "soundcraft";
    rev = "v${version}";
    hash = "sha256-rOFqnKmhbokRZQObNGBQOeqeXT6sZwO623G/7oUPJGk=";
  };

  cargoHash = "sha256-4zY/R2IJ8lpSrEx6+7cEtdsrjgPhyzwngbMoRk5yErk=";

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
    SOUNDCRAFT_BUILD_SHA = commit;
    SOUNDCRAFT_BUILD_DATE = buildDate;
  };

  postInstall = ''
    install -Dm644 packaging/linux/ai.storyteller.soundcraft.desktop $out/share/applications/ai.storyteller.soundcraft.desktop
    install -Dm644 packaging/linux/ai.storyteller.soundcraft.mime.xml $out/share/mime/packages/ai.storyteller.soundcraft.xml

    mkdir -p $out/share/metainfo
    sed -e "s/@VERSION@/${version}/g" -e "s/@DATE@/${buildDate}/g" \
      packaging/linux/ai.storyteller.soundcraft.metainfo.xml.in > $out/share/metainfo/ai.storyteller.soundcraft.metainfo.xml

    mkdir -p $out/share/icons
    cp -r assets/app-icon/hicolor $out/share/icons/

    mkdir -p $out/share/doc/soundcraft
    for f in README.md LICENSE LICENSE-MIT LICENSE-APACHE COPYRIGHT NOTICE ATTRIBUTION.md; do
      if [ -f "$f" ]; then
        install -Dm644 "$f" "$out/share/doc/soundcraft/$f"
      fi
    done
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
        wrapProgram $out/bin/soundcraft \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
          ${
            lib.optionalString (xwayland != null) "--prefix PATH : \"${lib.makeBinPath [ xwayland ]}\""
          } \
          ${lib.optionalString defaultToXWayland "--unset WAYLAND_DISPLAY --unset WAYLAND_SOCKET"}

        wrapProgram $out/bin/soundcraft-cli \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}"

        makeWrapper $out/bin/.soundcraft-wrapped $out/bin/soundcraft-xwayland \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
          ${
            lib.optionalString (xwayland != null) "--prefix PATH : \"${lib.makeBinPath [ xwayland ]}\""
          } \
          --unset WAYLAND_DISPLAY \
          --unset WAYLAND_SOCKET

        makeWrapper $out/bin/.soundcraft-wrapped $out/bin/soundcraft-wayland \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
          ${lib.optionalString (xwayland != null) "--prefix PATH : \"${lib.makeBinPath [ xwayland ]}\""}

        cat >> $out/share/applications/ai.storyteller.soundcraft.desktop <<EOF

    Actions=XWayland;Wayland;

    [Desktop Action XWayland]
    Name=Open under XWayland (Drag and Drop support)
    Exec=soundcraft-xwayland %F

    [Desktop Action Wayland]
    Name=Open under native Wayland
    Exec=soundcraft-wayland %F
    EOF
  '';

  meta = with lib; {
    description = "Clean-room digital audio workstation (DAW) in pure Rust";
    homepage = "https://github.com/storytold/soundcraft";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ johnrizzo1 ];
    mainProgram = "soundcraft";
    platforms = platforms.unix;
  };
}
