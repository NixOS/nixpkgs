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
  libxkbcommon,
  wrapGAppsHook3,
  wayland,
  gobject-introspection,
  libxxf86vm,
  libxrandr,
  libxi,
  libxcursor,
  libx11,
  libxcb,
}:
let
  rpathLibs = lib.optionals stdenv.hostPlatform.isLinux [
    libGL
    libxkbcommon
    libx11
    libxcursor
    libxi
    libxrandr
    libxxf86vm
    libxcb
    wayland
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lapce";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "lapce";
    repo = "lapce";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-D5DEmMkCAkMiMMzYP8FoVIUeT2CDOepUWUlUqWSaUnM=";
  };

  cargoHash = "sha256-BFaR8jWdET2nInBkKZhnoqLCB1dnXH3pywkD1Cv5SuE=";

  env = {
    # Get openssl-sys to use pkg-config
    OPENSSL_NO_VENDOR = 1;

    # This variable is read by build script, so that Lapce editor knows its version
    RELEASE_TAG_NAME = "v${finalAttrs.version}";
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

  meta = {
    description = "Lightning-fast and Powerful Code Editor written in Rust";
    homepage = "https://github.com/lapce/lapce";
    changelog = "https://github.com/lapce/lapce/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [ asl20 ];
    mainProgram = "lapce";
  };
})
