{ stdenv
, lib
, fetchzip
, copyDesktopItems
, makeDesktopItem
, makeWrapper
, runCommand
, appimageTools
<<<<<<< HEAD
, icu
}:
let
  pname = "jetbrains-toolbox";
  version = "2.0.2.16660";

  src = fetchzip {
    url = "https://download.jetbrains.com/toolbox/jetbrains-toolbox-${version}.tar.gz";
    sha256 = "sha256-iz9bUkeQZs0k3whRZuIl/KtSn7KlTq1urQ2I+D292MM=";
=======
, patchelf
}:
let
  pname = "jetbrains-toolbox";
  version = "1.28.1.15219";

  src = fetchzip {
    url = "https://download.jetbrains.com/toolbox/jetbrains-toolbox-${version}.tar.gz";
    sha256 = "sha256-4P73MC5Go8wLACBtjh1y3Ao0czE/3hsSI4728mNjKxA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    makeWrapper ${appimage}/bin/${pname}-${version} $out/bin/${pname} \
      --append-flags "--update-failed" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [icu]}
=======
    makeWrapper ${appimage}/bin/${pname}-${version} $out/bin/${pname} --append-flags "--update-failed"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
