{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, fontconfig
, libGL
, libX11
, libXcursor
, libXi
, libXrandr
, cmake
, libxkbcommon
, wayland
, makeWrapper
}:

rustPlatform.buildRustPackage rec {
  pname = "gpustat";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "arduano";
    repo = "gpustat";
    rev = "v${version}";
    hash = "sha256-M9P/qfw/tp9ogkNOE3b2fD2rGFnii1/VwmqJHqXb7Mg=";
  };

  cargoHash = "sha256-po/pEMZEtySZnz7l2FI7Wqbmp2CiWBijchKGkqlIMPU=";

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    fontconfig
    libGL
    libX11
    libXcursor
    libXi
    libXrandr
    libxkbcommon
    wayland
  ];

  postInstall = ''
    mkdir -p $out/share/applications $out/share/pixmaps

    cp assets/gpustat.desktop $out/share/applications
    cp assets/gpustat_icon_* $out/share/pixmaps
  '';

  # Wrap the program in a script that sets the LD_LIBRARY_PATH environment variable
  # so that it can find the shared libraries it depends on. This is currently a
  # requirement for running Rust programs that depend on `egui` within a Nix environment.
  # https://github.com/emilk/egui/issues/2486
  postFixup = ''
    wrapProgram $out/bin/gpustat \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}:/run/opengl-driver/lib"
  '';

  meta = with lib; {
    description = "Simple utility for viewing GPU utilization";
    homepage = "https://github.com/arduano/gpustat";
    license = licenses.asl20;
    maintainers = with maintainers; [ arduano ];
    mainProgram = "gpustat";
    platforms = platforms.linux;
  };
}
