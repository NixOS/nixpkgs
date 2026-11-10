{
  lib,
  stdenv,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  wrapGAppsHook3,
  gtk3,
  gdk-pixbuf,
  glib,
  sane-backends,
  libnotify,
  libtiff,
}:

buildDotnetModule rec {
  pname = "naps2";
  version = "8.6.0";

  src = fetchFromGitHub {
    owner = "cyanfish";
    repo = "naps2";
    tag = "v${version}";
    hash = "sha256-FPWup4pvtIpbP1EyKdQzLAx1On3G7xB3yi+/ksRGrfM=";
  };

  patches = [
    ./01-donate-button.patch
    ./02-button-dpi.patch
  ];

  projectFile = "NAPS2.App.Gtk/NAPS2.App.Gtk.csproj";
  nugetDeps = ./deps.json;

  dotnetFlags = [
    "-p:TargetFrameworks=net10.0"
  ];

  executables = [ "naps2" ];

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  nativeBuildInputs = [ wrapGAppsHook3 ];

  selfContainedBuild = true;
  runtimeDeps = [
    gtk3
    gdk-pixbuf
    glib
    sane-backends
    libnotify
    libtiff
  ];

  postInstall = ''
    install -D NAPS2.Setup/config/linux/com.naps2.Naps2.desktop $out/share/applications/com.naps2.Naps2.desktop
    for size in 16 32 48 128; do
      install -D NAPS2.Lib/Icons/scanner_$size.png \
        $out/share/icons/hicolor/"$size"x"$size"/apps/com.naps2.Naps2.png
    done
    install -D NAPS2.Lib/Icons/svg/scanner.svg $out/share/icons/hicolor/scalable/apps/com.naps2.Naps2.svg
    case "${stdenv.hostPlatform.system}" in
      x86_64-linux)
        chmod a+x $out/lib/naps2/_linux/tesseract
        ;;
      aarch64-linux)
        chmod a+x $out/lib/naps2/_linuxarm/tesseract
        ;;
    esac
  '';

  meta = {
    description = "Scan documents to PDF and more, as simply as possible";
    homepage = "https://www.naps2.com";
    changelog = "https://github.com/cyanfish/naps2/blob/master/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      eliandoran
      magicquark
    ];
    platforms = lib.platforms.linux;
    mainProgram = "naps2";
  };
}
