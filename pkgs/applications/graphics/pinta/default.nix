{ lib
, buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
, gtk3
, installShellFiles
, librsvg
, makeDesktopItem
, wrapGAppsHook
}:

buildDotnetModule rec {
  pname = "Pinta";
  version = "2.0.1";

  nativeBuildInputs = [
    installShellFiles
    wrapGAppsHook
  ];

  runtimeDeps = [ gtk3 ];

  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.runtime_6_0;

  # How-to update deps:
  # $ nix-build -A pinta.fetch-deps
  # $ ./result
  # $ cp /tmp/Pinta-deps.nix ./pkgs/applications/graphics/pinta/default.nix
  # TODO: create update script
  nugetDeps = ./deps.nix;

  projectFile = "Pinta";

  src = fetchFromGitHub {
    owner = "PintaProject";
    repo = "Pinta";
    rev = version;
    sha256 = "sha256-iOKJPB2bI/GjeDxzG7r6ew7SGIzgrJTcRXhEYzOpC9k=";
  };

  # FIXME: this should be propagated by wrapGAppsHook already, however for some
  # reason it is not working. Maybe a bug in buildDotnetModule?
  preInstall = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}"
      --set GDK_PIXBUF_MODULE_FILE ${librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache
    )
  '';

  postInstall = ''
    # Rename the binary
    mv $out/bin/Pinta $out/bin/pinta

    # Copy desktop icons
    for size in 16x16 22x22 24x24 32x32 96x96 scalable; do
      mkdir -p $out/share/icons/hicolor/$size/apps
      cp xdg/$size/* $out/share/icons/hicolor/$size/apps/
    done

    # Copy runtime icons
    cp -r Pinta.Resources/icons/hicolor/16x16/* $out/share/icons/hicolor/16x16/

    # Install manpage
    installManPage xdg/pinta.1

    # Fix and copy desktop file
    # TODO: fix this propely by using the autoreconf+pkg-config build system
    # from upstream
    mkdir -p $out/share/applications
    substitute xdg/pinta.desktop.in $out/share/applications/Pinta.desktop \
      --replace _Name Name \
      --replace _Comment Comment \
      --replace _GenericName GenericName \
      --replace _X-GNOME-FullName X-GNOME-FullName \
      --replace _Keywords Keywords
  '';

  meta = {
    homepage = "https://www.pinta-project.com/";
    description = "Drawing/editing program modeled after Paint.NET";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thiagokokada ];
    platforms = with lib.platforms; linux;
    mainProgram = "pinta";
  };
}
