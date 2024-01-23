{ lib
, buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
, gtk3
, gdk-pixbuf
, glib
, sane-backends
, libnotify
}:

buildDotnetModule rec {
  pname = "naps2";
  version = "7.3.0";

  src = fetchFromGitHub {
    owner = "cyanfish";
    repo = "naps2";
    rev = "v${version}";
    hash = "sha256-aR4IDPfcbWWyM+1MhSWIsNUNLi43MvbWBykoEkVbe+4=";
  };

  projectFile = "NAPS2.App.Gtk/NAPS2.App.Gtk.csproj";
  nugetDeps = ./deps.nix;

  executables = [ "naps2" ];

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
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
  '';

  meta = {
    description = "Scan documents to PDF and more, as simply as possible.";
    homepage = "www.naps2.com";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ eliandoran ];
    platforms = lib.platforms.linux;
    mainProgram = "naps2";
  };

}
