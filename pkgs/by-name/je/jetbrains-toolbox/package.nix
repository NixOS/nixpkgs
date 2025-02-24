{
  stdenv,
  lib,
  fetchzip,
  copyDesktopItems,
  makeWrapper,
  runCommand,
  appimageTools,
  icu,
  genericUpdater,
  writeShellScript,
  jq,
}:
let
  pname = "jetbrains-toolbox";
  version = "2.5.3.37797";

  src = fetchzip {
    url = "https://download.jetbrains.com/toolbox/jetbrains-toolbox-${version}.tar.gz";
    hash = "sha256-BMSVigKiR7HgBqaebKvBk0OnyqiYQk562IIzN/6xu2I=";
    stripRoot = false;
  };

  appimageContents =
    runCommand "${pname}-extracted"
      {
        nativeBuildInputs = [ appimageTools.appimage-exec ];
      }
      ''
        appimage-exec.sh -x $out ${src}/jetbrains-toolbox-${version}/jetbrains-toolbox

        # JetBrains ship a broken desktop file. Despite registering a custom
        # scheme handler for jetbrains:// URLs, they never mark the command as
        # being suitable for passing URLs to. Ergo, the handler never receives
        # its payload. This causes various things to break, including login.
        # Reported upstream at: https://youtrack.jetbrains.com/issue/TBX-11478/
        sed -Ei '/^Exec=/s/( %U)?$/ %U/' $out/jetbrains-toolbox.desktop
      '';

  appimage = appimageTools.wrapAppImage {
    inherit pname version;
    src = appimageContents;
  };
in
stdenv.mkDerivation {
  inherit
    pname
    version
    src
    appimage
    ;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 ${appimageContents}/.DirIcon $out/share/icons/hicolor/scalable/apps/jetbrains-toolbox.svg
    makeWrapper ${appimage}/bin/jetbrains-toolbox $out/bin/jetbrains-toolbox \
      --append-flags "--update-failed" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ icu ]}

    runHook postInstall
  '';

  desktopItems = [ "${appimageContents}/jetbrains-toolbox.desktop" ];

  # Disabling the tests, this seems to be very difficult to test this app.
  doCheck = false;

  passthru.updateScript = genericUpdater {
    versionLister = writeShellScript "jetbrains-toolbox-versionLister" ''
      curl -Ls 'https://data.services.jetbrains.com/products?code=TBA&release.type=release' \
        | ${lib.getExe jq} -r '.[] | .releases | flatten[] | .build'
    '';
  };

  meta = {
    description = "Jetbrains Toolbox";
    homepage = "https://jetbrains.com/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ AnatolyPopov ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "jetbrains-toolbox";
  };
}
