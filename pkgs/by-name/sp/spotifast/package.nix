{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
  cacert,
  makeWrapper,
  icnsify,
  nix-update-script,
  dbus,
  rcodesign,
  alsa-lib,
  libpulseaudio,
  libGL,
  libx11,
  libxkbcommon,
  wayland,
  libxcursor,
  libxi,
  libxrandr,
  apple-sdk_15,
}:

let
  runtimeLibraries = [
    dbus
    libxkbcommon
    wayland
    libGL
    libx11
    libxcursor
    libxi
    libxrandr
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "spotifast";
  version = "0.11.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "crmne";
    repo = "spotifast";
    tag = "v${version}";
    hash = "sha256-jp8iDO0b/EoFvZWB7n3hRtRma2Vx1f9UeZpLlgXtwcY=";
  };

  cargoHash = "sha256-Ed4Bim++LqzZ/DY+SjF5WS0DWs3Wg0Vb3WWgxL0URn8=";

  # projectm-sys only searches lib, while CMake may otherwise install to lib64.
  postPatch = ''
    substituteInPlace "$cargoDepsCopy"/source-git-*/projectm-sys-*/build.rs \
      --replace-fail \
      '.define("BUILD_SHARED_LIBS", build_shared_libs)' \
      '.define("CMAKE_INSTALL_LIBDIR", "lib").define("BUILD_SHARED_LIBS", build_shared_libs)'
  '';

  # The proxy test needs a valid CA bundle.
  preCheck = ''
    export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    rustPlatform.bindgenHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ makeWrapper ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    rcodesign
    icnsify
  ];

  nativeCheckInputs = lib.optionals stdenv.hostPlatform.isLinux [ dbus ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      libpulseaudio
      libGL
      libx11
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_15 ];

  postFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      wrapProgram $out/bin/fastpotify \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibraries}
      wrapProgram $out/bin/spotifast \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibraries}
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      rcodesign sign "$out/Applications/Spotifast.app"
    '';

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm644 packaging/applications/spotifast.desktop \
        $out/share/applications/spotifast.desktop
      install -Dm644 packaging/icons/spotifast.svg \
        $out/share/icons/hicolor/scalable/apps/spotifast.svg
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      app="$out/Applications/Spotifast.app/Contents"
      mkdir -p "$app/MacOS" "$app/Resources"
      executable=Spotifast
      identifier=rocks.spotifast.Spotifast
      cp "$out/bin/spotifast" "$app/MacOS/$executable"
      icnsify packaging/macos/icon-1024.png -o "$app/Resources/spotifast.icns"
      substitute packaging/macos/Info.plist "$app/Info.plist" \
        --replace-fail __VERSION__ "${version}" \
        --replace-fail __BUILD__ "${lib.head (lib.splitString "-" version)}" \
        --replace-fail __EXECUTABLE__ "$executable" \
        --replace-fail __IDENTIFIER__ "$identifier"
    '';

  passthru.updateScript = nix-update-script { };

  __darwinAllowLocalNetworking = true;
  # CoreText's fallback test reads the system font files.
  __impureHostDeps = lib.optionals stdenv.hostPlatform.isDarwin [
    "/System/Library/Fonts"
  ];

  meta = {
    description = "Fast native Spotify client with local playback and Spotify Connect";
    homepage = "https://spotifast.rocks";
    changelog = "https://github.com/crmne/spotifast/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ DmitrySkibitsky ];
    mainProgram = "spotifast";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
