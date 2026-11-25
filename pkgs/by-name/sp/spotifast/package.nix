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
  pipewire,
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
    pipewire
    libpulseaudio
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "spotifast";
  version = "0.17.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "crmne";
    repo = "spotifast";
    tag = "v${version}";
    hash = "sha256-ccMYbLHgoHYzb+ikQgfegheLNTB6t6Bx7o9VAoqlPCg=";
  };

  cargoHash = "sha256-2mPuPkJn+46rhbJzjnCK14otZne9BwgNxP1e5b8Z65k=";

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

  # Orphan soloist process never appears in the Nix sandbox; upstream CI runs it outside Nix.
  checkFlags = [
    "--skip=soloist::tests::reclaims_a_leftover_soloist_from_this_installation"
  ]
  # The child process outlives its killed parent in the Darwin sandbox.
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=soloist::owned::tests::a_child_dies_with_its_killed_parent"
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      libpulseaudio
      pipewire
      libGL
      libx11
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_15 ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = "-lclang_rt.osx"; # `soloist_audio` uses @available; needs compiler-rt on Darwin.
  };

  postFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
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
