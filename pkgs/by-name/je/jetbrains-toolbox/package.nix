{ stdenv
, lib
, fetchurl
, fetchzip
, copyDesktopItems
, makeWrapper
, runCommand
, appimageTools
, icu
, genericUpdater
, writeShellScript
, undmg
, unzip
}:
let
  pname = "jetbrains-toolbox";
  version = "2.5.1.34629";

  src =
    if stdenv.system == "x86_64-linux" then (
      fetchzip {
        url = "https://download.jetbrains.com/toolbox/jetbrains-toolbox-${version}.tar.gz";
        hash = "sha256-YaMlvgktoa738grHarJX2Uh5PZ7qHuASyJBcUhMssEI=";
        stripRoot = false;
      })
    else if stdenv.system == "aarch64-linux" then (
      fetchzip {
        url = "https://download.jetbrains.com/toolbox/jetbrains-toolbox-${version}-arm64.tar.gz";
        hash = "sha256-rTGzSmbm7WyKAls6Len2C27JJssGR7vZooy2qq6ZE/o=";
        stripRoot = false;
      })
    else if stdenv.system == "aarch64-darwin" then (
      fetchurl {
        url = "https://download.jetbrains.com/toolbox/jetbrains-toolbox-${version}-arm64.dmg";
        hash = "sha256-x5/Qeg/Ih0JDMvxI+TOk4wg6Y3xNR8x4NVoq8OXvdiE=";
      })
    else throw "Unsupported platform";

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

  darwinappname = "JetBrains Toolbox";
in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs =
    [ makeWrapper ]
    ++ lib.optionals stdenv.isLinux [ copyDesktopItems ]
    ++ lib.optionals stdenv.isDarwin [ undmg unzip ];

  sourceRoot = lib.optionalString stdenv.isDarwin "${darwinappname}.app";

  installPhase =
    if stdenv.isLinux then ''
      runHook preInstall

      install -Dm644 ${appimageContents}/.DirIcon $out/share/icons/hicolor/scalable/apps/jetbrains-toolbox.svg
      makeWrapper ${appimage}/bin/jetbrains-toolbox $out/bin/jetbrains-toolbox \
        --append-flags "--update-failed" \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [icu]}

      runHook postInstall
    ''
    else if stdenv.isDarwin then ''
      runHook preInstall
      mkdir -p $out/{Applications/'${darwinappname}.app',bin}
      cp -R . $out/Applications/'${darwinappname}.app'
      makeWrapper $out/Applications/'${darwinappname}.app'/Contents/MacOS/${pname} $out/bin/${pname}
      runHook postInstall
    ''
    else throw "Unsupported platform";

  desktopItems = lib.optional stdenv.isLinux "${appimageContents}/jetbrains-toolbox.desktop";

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
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "jetbrains-toolbox";
  };
}
