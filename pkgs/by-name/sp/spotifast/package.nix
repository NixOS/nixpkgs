{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
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
  version = "0.8.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "crmne";
    repo = "spotifast";
    tag = "v${version}";
    hash = "sha256-cX9DXG4u7mBSl6sO768A1vJ9kHZZc12+STzRU0KuWh0=";
  };

  cargoHash = "sha256-A17V9f8cueyYaX/aIPMTTYERGSxNbSJrd0bpwDZXUyI=";

  # projectm-sys only searches lib, while CMake may otherwise install to lib64.
  postPatch = ''
    substituteInPlace "$cargoDepsCopy"/source-git-*/projectm-sys-*/build.rs \
      --replace-fail \
      '.define("BUILD_SHARED_LIBS", build_shared_libs)' \
      '.define("CMAKE_INSTALL_LIBDIR", "lib").define("BUILD_SHARED_LIBS", build_shared_libs)'
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
      install -Dm644 packaging/applications/fastpotify.desktop \
        $out/share/applications/fastpotify.desktop
      install -Dm644 packaging/icons/fastpotify.svg \
        $out/share/icons/hicolor/scalable/apps/fastpotify.svg
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      app="$out/Applications/Spotifast.app/Contents"
      mkdir -p "$app/MacOS" "$app/Resources"
      cp "$out/bin/fastpotify" "$app/MacOS/fastpotify"
      icnsify packaging/macos/icon-1024.png -o "$app/Resources/fastpotify.icns"
      substitute packaging/macos/Info.plist "$app/Info.plist" \
        --replace-fail __VERSION__ "${version}" \
        --replace-fail __BUILD__ "${version}"
    '';

  passthru.updateScript = nix-update-script { };

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
