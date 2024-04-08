{ stdenv
, lib
, fetchzip
, copyDesktopItems
, makeWrapper
, runCommand
, appimageTools
, icu
}:
let
  pname = "jetbrains-toolbox";
  version = "2.2.3.20090";

  src = fetchzip {
    url = "https://download.jetbrains.com/toolbox/jetbrains-toolbox-${version}.tar.gz";
    sha256 = "sha256-SqxQF5pG61CySsDzdZ1P2C9cCe/B145D0S+T4NByif8=";
    stripRoot = false;
  };

  appimageContents = runCommand "${pname}-extracted"
    {
      nativeBuildInputs = [ appimageTools.appimage-exec ];
    }
    ''
      appimage-exec.sh -x $out ${src}/${pname}-${version}/${pname}

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
    extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.targetPkgs pkgs);
  };
in
stdenv.mkDerivation {
  inherit pname version src appimage;

  nativeBuildInputs = [ makeWrapper copyDesktopItems ];

  installPhase = ''
    runHook preInstall

    install -Dm644 ${appimageContents}/.DirIcon $out/share/icons/hicolor/scalable/apps/jetbrains-toolbox.svg
    makeWrapper ${appimage}/bin/${pname}-${version} $out/bin/${pname} \
      --append-flags "--update-failed" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [icu]}

    runHook postInstall
  '';

  desktopItems = [ "${appimageContents}/jetbrains-toolbox.desktop" ];

  # Disabling the tests, this seems to be very difficult to test this app.
  doCheck = false;

  meta = with lib; {
    description = "Jetbrains Toolbox";
    homepage = "https://jetbrains.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ AnatolyPopov ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "jetbrains-toolbox";
  };
}
