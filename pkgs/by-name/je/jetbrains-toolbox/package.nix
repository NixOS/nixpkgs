{ stdenv
, lib
, fetchzip
, copyDesktopItems
, makeWrapper
, runCommand
, appimageTools
, icu
, genericUpdater
, writeShellScript
}:
let
  pname = "jetbrains-toolbox";
  version = "2.5.1.34629";

  src = fetchzip {
    url = "https://download.jetbrains.com/toolbox/jetbrains-toolbox-${version}.tar.gz";
    hash = "sha256-YaMlvgktoa738grHarJX2Uh5PZ7qHuASyJBcUhMssEI=";
    stripRoot = false;
  };

  appimageContents = runCommand "${pname}-extracted"
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
  inherit pname version src appimage;

  nativeBuildInputs = [ makeWrapper copyDesktopItems ];

  installPhase = ''
    runHook preInstall

    install -Dm644 ${appimageContents}/.DirIcon $out/share/icons/hicolor/scalable/apps/jetbrains-toolbox.svg
    makeWrapper ${appimage}/bin/jetbrains-toolbox $out/bin/jetbrains-toolbox \
      --append-flags "--update-failed" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [icu]}

    runHook postInstall
  '';

  desktopItems = [ "${appimageContents}/jetbrains-toolbox.desktop" ];

  # Disabling the tests, this seems to be very difficult to test this app.
  doCheck = false;

  passthru.updateScript = genericUpdater {
    versionLister = writeShellScript "jetbrains-toolbox-versionLister" ''
      curl -Ls 'https://data.services.jetbrains.com/products?code=TBA&release.type=release' \
        | jq -r '.[] | .releases | flatten[] | .build'
    '';
  };

  meta = with lib; {
    description = "Jetbrains Toolbox";
    homepage = "https://jetbrains.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ AnatolyPopov ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "jetbrains-toolbox";
  };
}
