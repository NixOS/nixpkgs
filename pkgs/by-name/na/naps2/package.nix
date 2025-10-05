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
}:

buildDotnetModule rec {
  pname = "naps2";
  version = "8.2.1";

  src = fetchFromGitHub {
    owner = "cyanfish";
    repo = "naps2";
    tag = "v${version}";
    hash = "sha256-1OPFWmy9eDRnMJjYdzYubgfde7MNix8ZsSuN2ZHsvco=";
  };

  patches = [
    ./01-donate-button.patch
    ./02-button-dpi.patch
  ];

  projectFile = "NAPS2.App.Gtk/NAPS2.App.Gtk.csproj";
  nugetDeps = ./deps.json;

  dotnetFlags = [
    "-p:TargetFrameworks=net9"
  ];

  executables = [ "naps2" ];

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;

  nativeBuildInputs = [ wrapGAppsHook3 ];

  selfContainedBuild = true;
  runtimeDeps = [
    gtk3
    gdk-pixbuf
    glib
    sane-backends
    libnotify
  ];

  postInstall = ''
    install -D NAPS2.Setup/config/linux/com.naps2.Naps2.desktop $out/share/applications/com.naps2.Naps2.desktop
    install -D NAPS2.Lib/Icons/scanner-16-rev0.png $out/share/icons/hicolor/16x16/apps/com.naps2.Naps2.png
    install -D NAPS2.Lib/Icons/scanner-32-rev2.png $out/share/icons/hicolor/32x32/apps/com.naps2.Naps2.png
    install -D NAPS2.Lib/Icons/scanner-48-rev2.png $out/share/icons/hicolor/48x48/apps/com.naps2.Naps2.png
    install -D NAPS2.Lib/Icons/scanner-64-rev2.png $out/share/icons/hicolor/64x64/apps/com.naps2.Naps2.png
    install -D NAPS2.Lib/Icons/scanner-72-rev1.png $out/share/icons/hicolor/72x72/apps/com.naps2.Naps2.png
    install -D NAPS2.Lib/Icons/scanner-128.png $out/share/icons/hicolor/128x128/apps/com.naps2.Naps2.png
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
    maintainers = with lib.maintainers; [ eliandoran ];
    platforms = lib.platforms.linux;
    mainProgram = "naps2";
  };

}
