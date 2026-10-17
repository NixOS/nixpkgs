{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  clangStdenv,
  gtk3,
  libxrandr,
  libxi,
  libxcursor,
  libx11,
  libxcb,
  perl,
  pkg-config,
  openssl,
  speechd-minimal,
  libxkbcommon,
  libGL,
  wayland,
}:
let
  rpathLibs = [
    speechd-minimal
    openssl
    gtk3
    libxkbcommon
    libGL

    # WINIT_UNIX_BACKEND=wayland
    wayland

    # WINIT_UNIX_BACKEND=x11
    libxcursor
    libxrandr
    libxi
    libx11
    libxcb
  ];
in
rustPlatform.buildRustPackage.override { stdenv = clangStdenv; } rec {
  pname = "BoilR";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "PhilipK";
    repo = "BoilR";
    tag = "v.${version}";
    hash = "sha256-rCzcycoglUMd6j2Bnnt30nBsKGfGI48OlhQHX8v3xDI=";
  };

  cargoHash = "sha256-nDvHCW1LRMN9cSpOEFxrfl6Zwii5s9D1cpC2vLUSB8g=";

  nativeBuildInputs = [
    perl
    pkg-config
  ];

  buildInputs = rpathLibs;

  postInstall = ''
    patchelf --add-rpath "${lib.makeLibraryPath rpathLibs}" $out/bin/boilr
    install -Dpm 0644 flatpak/io.github.philipk.boilr.desktop $out/share/applications/boilr.desktop
    install -Dpm 0644 resources/io.github.philipk.boilr.png -t $out/share/icons/hicolor/32x32/apps
  '';

  dontPatchELF = true;

  meta = {
    description = "Automatically adds (almost) all your games to your Steam library (including image art)";
    homepage = "https://github.com/PhilipK/BoilR";
    license = with lib.licenses; [
      asl20
      mit
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ foolnotion ];
    mainProgram = "boilr";
  };
}
