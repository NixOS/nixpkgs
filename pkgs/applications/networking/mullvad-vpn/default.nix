{
  lib,
  fetchFromGitHub,
  dbus,
  glib,
  nss,
  gtk3,
  autoPatchelfHook,
  makeWrapper,
  buildNpmPackage,
  electron,
  nodejs_20,
  protobuf,
}:
buildNpmPackage rec {
  pname = "mullvad-vpn";
  version = "2024.4";

  src = fetchFromGitHub {
    owner = "mullvad";
    repo = "mullvadvpn-app";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-d7poR1NnvqaPutXLFizpQnyipl+38N1Qe2zVXeV7v1Q=";
  };

  sourceRoot = "source/gui";
  makeCacheWritable = true;

  npmFlags = [
    "--ignore-scripts"
  ];

  npmDepsHash = "sha256-Cs4rTfLDtVJL5sK3poBVt7RRedsxkQguQ3wfIvwUeUA=";

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  buildInputs = [
    dbus
    glib
    gtk3
    nss
    electron
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    electron
    nodejs_20
    protobuf
  ];

  buildPhase = ''
    runHook preBuild

    npm --ignore-scripts --ignore-optional install

    npm --ignore-scripts --ignore-optional run build

    npm exec electron-builder  -- \
      --dir \
      -c.electronDist=${electron}/libexec/electron \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/mullvadvpn-gui/
    cp -r dist/*-unpacked/{locales,resources{,.pak}} $out/share/mullvadvpn-gui/

    makeWrapper ${lib.getExe electron} $out/bin/mullvadvpn-gui \
        --add-flags $out/share/mullvadvpn-gui/resources/app.asar \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAU:+--ozone-platform-hinti=auto --enable-features=WaylandWindowDecorations}}" \
        --inherit-argv0

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/mullvad/mullvadvpn-app";
    description = "Client for Mullvad VPN";
    changelog = "https://github.com/mullvad/mullvadvpn-app/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    platforms = ["x86_64-linux" "aarch64-linux"];
    maintainers = with maintainers; [Br1ght0ne ymarkus ataraxiasjel];
  };
}
