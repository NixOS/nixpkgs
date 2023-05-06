{ stdenv
, lib
, fetchzip
, copyDesktopItems
, makeDesktopItem
, makeWrapper
, runCommand
, appimageTools
, patchelf
}:
let
  pname = "jetbrains-toolbox";
  version = "1.28.0.15158";

  src = fetchzip {
    url = "https://download.jetbrains.com/toolbox/jetbrains-toolbox-${version}.tar.gz";
    sha256 = "sha256-IHs3tQtFXGS9xa5lKwSEWvp8aNffrCjNcoVE4tGX9ak=";
    stripRoot = false;
  };

  appimageContents = runCommand "${pname}-extracted"
    {
      nativeBuildInputs = [ appimageTools.appimage-exec ];
    }
    ''
      appimage-exec.sh -x $out ${src}/${pname}-${version}/${pname}
    '';

  appimage = appimageTools.wrapAppImage {
    inherit pname version;
    src = appimageContents;
    extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.targetPkgs pkgs);
  };

  desktopItem = makeDesktopItem {
    name = "JetBrains Toolbox";
    exec = "jetbrains-toolbox";
    comment = "JetBrains Toolbox";
    desktopName = "JetBrains Toolbox";
    type = "Application";
    icon = "jetbrains-toolbox";
    terminal = false;
    categories = [ "Development" ];
    startupWMClass = "jetbrains-toolbox";
    startupNotify = false;
  };
in
stdenv.mkDerivation {
  inherit pname version src appimage;

  nativeBuildInputs = [ makeWrapper copyDesktopItems ];

  installPhase = ''
    runHook preInstall

    install -Dm644 ${appimageContents}/.DirIcon $out/share/icons/hicolor/scalable/apps/jetbrains-toolbox.svg
    makeWrapper ${appimage}/bin/${pname}-${version} $out/bin/${pname} --append-flags "--update-failed"

    runHook postInstall
  '';

  desktopItems = [ desktopItem ];

  # Disabling the tests, this seems to be very difficult to test this app.
  doCheck = false;

  meta = with lib; {
    description = "Jetbrains Toolbox";
    homepage = "https://jetbrains.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ AnatolyPopov ];
    platforms = [ "x86_64-linux" ];
  };
}
