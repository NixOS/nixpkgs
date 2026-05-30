{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  fontconfig,
  libGL,
  libx11,
  libxcursor,
  libxi,
  libxrandr,
  cmake,
  libxkbcommon,
  wayland,
  makeWrapper,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gpustat";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "arduano";
    repo = "gpustat";
    rev = "v${finalAttrs.version}";
    hash = "sha256-M9P/qfw/tp9ogkNOE3b2fD2rGFnii1/VwmqJHqXb7Mg=";
  };

  cargoHash = "sha256-8uD4zc33CeImvMW0mOTqws4S2xXQ3Ff9nPxocof0Xm4=";

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    fontconfig
    libGL
    libx11
    libxcursor
    libxi
    libxrandr
    libxkbcommon
    wayland
  ];

  postInstall = ''
    install -D assets/gpustat.desktop -t $out/share/applications
    install -D assets/gpustat_icon_16px.png $out/share/icons/hicolor/16x16/apps/gpustat.png
    install -D assets/gpustat_icon_32px.png $out/share/icons/hicolor/32x32/apps/gpustat.png
    install -D assets/gpustat_icon_64px.png $out/share/icons/hicolor/64x64/apps/gpustat.png
    substituteInPlace $out/share/applications/gpustat.desktop \
      --replace-fail "Icon=gpustat_icon_64px" "Icon=gpustat"
  '';

  # Wrap the program in a script that sets the LD_LIBRARY_PATH environment variable
  # so that it can find the shared libraries it depends on. This is currently a
  # requirement for running Rust programs that depend on `egui` within a Nix environment.
  # https://github.com/emilk/egui/issues/2486
  postFixup = ''
    wrapProgram $out/bin/gpustat \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}:/run/opengl-driver/lib"
  '';

  meta = {
    description = "Simple utility for viewing GPU utilization";
    homepage = "https://github.com/arduano/gpustat";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ arduano ];
    mainProgram = "gpustat";
    platforms = lib.platforms.linux;
  };
})
