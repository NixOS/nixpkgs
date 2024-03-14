{ lib
, stdenv
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
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "arduano";
    repo = "gpustat";
    rev = "v${version}";
    hash = "sha256-bgw9KrSiswfpKHn+qP1IiYgIuRzje+Ql/Mr0VqHvrbQ=";
  };

  cargoHash = "sha256-sUxuiOjBIn/5jckezX6S6TQtoiqjHnlOn8fRdaVRwYM=";

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
    cp assets/icon_* $out/share/pixmaps
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
    description = "A simple utility for viewing GPU utilization";
    homepage = "https://github.com/arduano/gpustat";
    license = licenses.asl20;
    maintainers = with maintainers; [ arduano ];
    mainProgram = "gpustat";
  };
}
