{
  lib,
  buildNpmPackage,
  substituteAll,
  protobuf,
  protoc-gen-js,
  grpc-tools,
  makeWrapper,
  electron,
  mullvad,
}:

buildNpmPackage rec {
  pname = "mullvad-vpn";
  inherit (mullvad) src version;

  patches = [
    (substituteAll {
      src = ./electron-builder.patch;
      version = version;
      electron_dist = electron.dist;
      electron_version = electron.version;
    })
  ];

  postPatch = ''
    cd gui
  '';

  npmDepsHash = "sha256-Cs4rTfLDtVJL5sK3poBVt7RRedsxkQguQ3wfIvwUeUA=";

  npmFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [
    makeWrapper
    protoc-gen-js
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    ELECTRON_OVERRIDE_DIST_PATH = electron.dist; # TODO: figure out why this is needed
  };

  postConfigure = ''
    ln -s ${lib.getBin mullvad}/bin/* ../dist-assets/
    ln -s ${lib.getExe' protobuf "protoc"} node_modules/grpc-tools/bin/protoc
    ln -s ${lib.getExe' grpc-tools "grpc_node_plugin"} node_modules/grpc-tools/bin/grpc_node_plugin
  '';

  npmBuildScript = "pack:linux";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/mullvadvpn-gui/
    cp -r ../dist/*-unpacked/{locales,resources{,.pak}} $out/share/mullvadvpn-gui/

    makeWrapper ${lib.getExe electron} $out/bin/mullvadvpn-gui \
        --add-flags $out/share/mullvadvpn-gui/resources/app.asar \
        --set MULLVAD_DISABLE_UPDATE_NOTIFICATION 1 \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
        --inherit-argv0

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/mullvad/mullvadvpn-app";
    description = "Client for Mullvad VPN";
    changelog = "https://github.com/mullvad/mullvadvpn-app/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    platforms = electron.meta.platforms;
    maintainers = with lib.maintainers; [
      Br1ght0ne
      ymarkus
      ataraxiasjel
    ];
  };
}
