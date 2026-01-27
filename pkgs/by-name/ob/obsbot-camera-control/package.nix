{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  pipewire,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "obsbot-camera-control";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "aaronsb";
    repo = "obsbot-camera-control";
    rev = "v${version}";
    hash = "sha256-akCzsM/19nkC6CjbqY8Z/OhjOZxWq3zLABWOUCoGnrY=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    makeWrapper
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtmultimedia
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON"
    "-DCMAKE_INSTALL_RPATH=${placeholder "out"}/lib"
  ];

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ pipewire ]}"
  ];

  installPhase = ''
    runHook preInstall

    # Install binaries
    install -Dm755 ../bin/obsbot-gui $out/bin/obsbot-gui
    install -Dm755 ../bin/obsbot-cli $out/bin/obsbot-cli

    # Install SDK library
    install -Dm755 ../sdk/lib/libdev.so.1.0.2 $out/lib/libdev.so.1.0.2
    ln -s libdev.so.1.0.2 $out/lib/libdev.so.1
    ln -s libdev.so.1.0.2 $out/lib/libdev.so

    # Install desktop file
    install -Dm644 ../obsbot-control.desktop $out/share/applications/obsbot-control.desktop

    # Install icon
    install -Dm644 ../resources/icons/camera.svg $out/share/icons/hicolor/scalable/apps/obsbot-control.svg

    # Install license
    install -Dm644 ../LICENSE $out/share/licenses/${pname}/LICENSE

    # Install systemd and modprobe configs
    install -Dm644 ../resources/modprobe.d/obsbot-virtual-camera.conf $out/lib/modprobe.d/obsbot-virtual-camera.conf
    install -Dm644 ../resources/systemd/obsbot-virtual-camera.service $out/lib/systemd/system/obsbot-virtual-camera.service

    runHook postInstall
  '';

  meta = with lib; {
    description = "Native Linux control app for OBSBOT cameras with PTZ, auto-framing, presets, and live preview";
    homepage = "https://github.com/aaronsb/obsbot-camera-control";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [ justanotherariel ];
    mainProgram = "obsbot-gui";
  };
}
