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
  version = "2.0.2";

  nativeBuildInputs = [
    installShellFiles
    wrapGAppsHook
  ];

  runtimeDeps = [ gtk3 ];
  buildInputs = runtimeDeps;

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
    sha256 = "sha256-Bvzs1beq7I1+10w9pmMePqGCz2TPDp5UK5Wa9hbKERU=";
  };

  postFixup = ''
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

  meta = with lib; {
    homepage = "https://www.pinta-project.com/";
    description = "Drawing/editing program modeled after Paint.NET";
    license = licenses.mit;
    maintainers = with maintainers; [ thiagokokada ];
    platforms = with platforms; linux;
    mainProgram = "pinta";
  };
}
