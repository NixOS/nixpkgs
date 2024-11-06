{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  clangStdenv,
  gtk3,
  xorg,
  perl,
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
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    xorg.libX11
    xorg.libxcb
  ];
in
rustPlatform.buildRustPackage.override { stdenv = clangStdenv; } rec {
  pname = "BoilR";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "PhilipK";
    repo = "BoilR";
    rev = "refs/tags/v.${version}";
    hash = "sha256-bwCTsoZ/9TeO3wyEcOqxKePnj9glsDXWUBCLd3nVT80=";
  };

  cargoPatches = [
    ./0001-update-time.patch
  ];

  cargoHash = "sha256-09vPP+kNrmk0nN3Bdn9T7QjvuZvJeqQ56lCQIFb+Zrs=";

  nativeBuildInputs = [ perl ];

  buildInputs = rpathLibs;

  postInstall = ''
    patchelf --add-rpath "${lib.makeLibraryPath rpathLibs}" $out/bin/boilr
    install -Dpm 0644 flatpak/io.github.philipk.boilr.desktop $out/share/applications/boilr.desktop
    install -Dpm 0644 resources/io.github.philipk.boilr.png $out/share/pixmaps/io.github.philipk.boilr.png
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
