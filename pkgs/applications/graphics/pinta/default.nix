{ lib
, buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
, glibcLocales
, gtk3
, intltool
, wrapGAppsHook
}:

buildDotnetModule rec {
  pname = "Pinta";
  version = "2.0.2";

  nativeBuildInputs = [
    intltool
    wrapGAppsHook
  ];

  runtimeDeps = [ gtk3 ];
  buildInputs = runtimeDeps;

  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.runtime_6_0;

  # How-to update deps:
  # $ nix-build -A pinta.fetch-deps
  # $ ./result
  # $ cp /tmp/Pinta-deps.nix ./pkgs/applications/graphics/pinta/deps.nix
  # TODO: create update script
  nugetDeps = ./deps.nix;

  projectFile = "Pinta";

  src = fetchFromGitHub {
    owner = "PintaProject";
    repo = "Pinta";
    rev = version;
    sha256 = "sha256-Bvzs1beq7I1+10w9pmMePqGCz2TPDp5UK5Wa9hbKERU=";
  };

  # https://github.com/NixOS/nixpkgs/issues/38991
  # bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
  LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive";

  # Do the autoreconf/Makefile job manually
  # TODO: use upstream build system
  postBuild = ''
    # Substitute translation placeholders
    intltool-merge -x po/ xdg/pinta.appdata.xml.in xdg/pinta.appdata.xml
    intltool-merge -d po/ xdg/pinta.desktop.in xdg/pinta.desktop

    # Build translations
    dotnet build Pinta \
      -p:ContinuousIntegrationBuild=true \
      -p:Deterministic=true \
      -target:CompileTranslations,PublishTranslations \
      -p:BuildTranslations=true \
      -p:PublishDir="$NIX_BUILD_TOP/source/publish"
  '';

  postFixup = ''
    # Rename the binary
    mv "$out/bin/Pinta" "$out/bin/pinta"

    # Copy runtime icons
    mkdir -p $out/share/icons/hicolor/16x16/
    cp -r Pinta.Resources/icons/hicolor/16x16/* $out/share/icons/hicolor/16x16/

    # Install
    dotnet build installer/linux/install.proj \
      -target:Install \
      -p:ContinuousIntegrationBuild=true \
      -p:Deterministic=true \
      -p:SourceDir="$NIX_BUILD_TOP/source" \
      -p:PublishDir="$NIX_BUILD_TOP/source/publish" \
      -p:InstallPrefix="$out"
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
