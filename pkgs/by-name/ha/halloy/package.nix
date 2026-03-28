{
  lib,
  stdenv,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  libxkbcommon,
  makeWrapper,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  vulkan-loader,
  wayland,
  xorg,
  alsa-lib,
  fetchpatch2,
}:

rustPlatform.buildRustPackage rec {
  pname = "halloy";
  version = "2025.12";

  src = fetchFromGitHub {
    owner = "squidowl";
    repo = "halloy";
    tag = version;
    hash = "sha256-rVeh0nvmRjfOErwUhiWBx3hHla9bA2mSOORNSqSOrfw=";
  };

  cargoHash = "sha256-lxRLTVtc2Gu3x3bt4po4q5/sfmRXb7CslEQIP8hX0+Q=";

  patches = [
    (fetchpatch2 {
      name = "CVE-2026-32733.patch";
      url = "https://github.com/squidowl/halloy/commit/0f77b2cfc5f822517a256ea5a4b94bad8bfe38b6.patch?full_index=1";
      hash = "sha256-hi3idb7obz7cGDzG9hdNMOjolGsEEZhjgc6T61Gee+Q=";
    })
    (fetchpatch2 {
      name = "CVE-2026-32810.patch";
      url = "https://github.com/squidowl/halloy/commit/f180e41061db393acf65bc99f5c5e7397586d9cb.patch?full_index=1";
      hash = "sha256-1S+xSwx/PANs8HSzQvXTAmzFJkZCw5BRUEttcl5v0pM=";
    })
  ];

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libxkbcommon
    vulkan-loader
    wayland
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libxcb
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "org.squidowl.halloy";
      desktopName = "Halloy";
      comment = "IRC client written in Rust";
      icon = "org.squidowl.halloy";
      exec = pname;
      terminal = false;
      mimeTypes = [
        "x-scheme-handler/irc"
        "x-scheme-handler/ircs"
        "x-scheme-handler/halloy"
      ];
      categories = [
        "Network"
        "IRCClient"
      ];
      keywords = [
        "IM"
        "Chat"
      ];
      startupWMClass = "org.squidowl.halloy";
    })
  ];

  postFixup = lib.optional stdenv.hostPlatform.isLinux (
    let
      rpathWayland = lib.makeLibraryPath [
        wayland
        vulkan-loader
        libxkbcommon
      ];
    in
    ''
      rpath=$(patchelf --print-rpath $out/bin/halloy)
      patchelf --set-rpath "$rpath:${rpathWayland}" $out/bin/halloy
    ''
  );

  postInstall = ''
    install -Dm644 assets/linux/icons/hicolor/128x128/apps/org.squidowl.halloy.png \
      $out/share/icons/hicolor/128x128/apps/org.squidowl.halloy.png
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    APP_DIR="$out/Applications/Halloy.app/Contents"

    mkdir -p "$APP_DIR/MacOS"
    cp -r ${src}/assets/macos/Halloy.app/Contents/* "$APP_DIR"

    substituteInPlace "$APP_DIR/Info.plist" \
      --replace-fail "{{ VERSION }}" "${version}" \
      --replace-fail "{{ BUILD }}" "${version}-nixpkgs"

    makeWrapper "$out/bin/halloy" "$APP_DIR/MacOS/halloy"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "IRC application";
    homepage = "https://github.com/squidowl/halloy";
    changelog = "https://github.com/squidowl/halloy/blob/${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      fab
      iivusly
      ivyfanchiang
    ];
    mainProgram = "halloy";
  };
}
