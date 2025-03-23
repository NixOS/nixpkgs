{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  cmake,
  pkg-config,
  perl,
  python3,
  fontconfig,
  glib,
  gtk3,
  openssl,
  libGL,
  libobjc,
  libxkbcommon,
  wrapGAppsHook3,
  wayland,
  gobject-introspection,
  xorg,
}:
let
  rpathLibs = lib.optionals stdenv.hostPlatform.isLinux [
    libGL
    libxkbcommon
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
    xorg.libXxf86vm
    xorg.libxcb
    wayland
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "lapce";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "lapce";
    repo = "lapce";
    tag = "v${version}";
    sha256 = "sha256-vBBYNHgZiW5JfGeUG6YZObf4oK0hHxTbsZNTfnIX95Y=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-cgSr1GHQUF4ccVd9w3TT0+EI+lqQpDzfXHdRWr75eDE=";

  env = {
    # Get openssl-sys to use pkg-config
    OPENSSL_NO_VENDOR = 1;

    # This variable is read by build script, so that Lapce editor knows its version
    RELEASE_TAG_NAME = "v${version}";
  };

  postPatch = ''
    substituteInPlace lapce-app/Cargo.toml --replace ", \"updater\"" ""
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    perl
    python3
    wrapGAppsHook3 # FIX: No GSettings schemas are installed on the system
    gobject-introspection
  ];

  buildInputs =
    rpathLibs
    ++ [
      glib
      gtk3
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      fontconfig
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libobjc
    ];

  postInstall =
    if stdenv.hostPlatform.isLinux then
      ''
        install -Dm0644 $src/extra/images/logo.svg $out/share/icons/hicolor/scalable/apps/dev.lapce.lapce.svg
        install -Dm0644 $src/extra/linux/dev.lapce.lapce.desktop $out/share/applications/lapce.desktop

        $STRIP -S $out/bin/lapce

        patchelf --add-rpath "${lib.makeLibraryPath rpathLibs}" $out/bin/lapce
      ''
    else
      ''
        mkdir $out/Applications
        cp -r extra/macos/Lapce.app $out/Applications
        ln -s $out/bin $out/Applications/Lapce.app/Contents/MacOS
      '';

  dontPatchELF = true;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Lightning-fast and Powerful Code Editor written in Rust";
    homepage = "https://github.com/lapce/lapce";
    changelog = "https://github.com/lapce/lapce/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ elliot ];
    mainProgram = "lapce";
  };
}
