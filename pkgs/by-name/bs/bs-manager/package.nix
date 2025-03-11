{
  asar,
  autoPatchelfHook,
  dpkg,
  electron,
  fetchurl,
  lib,
  makeWrapper,
  nix-update-script,
  openssl,
  stdenv,
  zlib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "bs-manager";
  version = "1.5.2";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://github.com/Zagrios/bs-manager/releases/download/v1.5.2/bs-manager_1.5.2_amd64.deb";
        hash = "sha256-rNqnEez56t4TPIKhljC0HEams2xhj6nB3CGW0CuQBKQ=";
      }
    else
      throw "BSManager is not available for your platform";

  # TODO: Package BSManager's fork of DepotDownloader and replace vendored binary at $out/opt/BSManager/resources/assets/scripts/DepotDownloader
  # See https://github.com/Iluhadesu/DepotDownloader

  nativeBuildInputs = [
    asar
    autoPatchelfHook # for vendored DepotDownloader
    dpkg
    makeWrapper
  ];

  buildInputs = [
    stdenv.cc.cc
    zlib
  ];

  # DepotDownloader dlopen()s libssl
  runtimeDependencies = [
    (lib.getLib openssl)
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/BSManager
    cp -r opt/BSManager/{locales,resources} $out/opt/BSManager
    cp -Tr usr/ $out

    # Some assets aren't included in the asar bundle. BSManager relies on
    # process.resourcesPath to load some of these assets which we have to patch later
    asar extract $out/opt/BSManager/resources/app.asar $out/opt/BSManager/resources
    rm $out/opt/BSManager/resources/app.asar

    # Update desktop Exec entry
    substituteInPlace $out/share/applications/bs-manager.desktop \
      --replace-fail Exec=/opt/BSManager/bs-manager Exec=bs-manager

    mkdir -p $out/bin
    makeWrapper ${lib.getExe electron} $out/bin/bs-manager \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --add-flags $out/opt/BSManager/resources \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --inherit-argv0

    runHook postInstall
  '';

  preFixup = ''
    substituteInPlace "$out/opt/BSManager/resources/dist/main/main.js" \
      --replace-fail "process.resourcesPath" "'$out/opt/BSManager/resources'"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/Zagrios/bs-manager/blob/master/CHANGELOG.md";
    description = "Your Beat Saber Assistant";
    homepage = "https://github.com/Zagrios/bs-manager";
    license = lib.licenses.gpl3Only;
    mainProgram = "bs-manager";
    maintainers = with lib.maintainers; [
      mistyttm
      Scrumplex
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
