{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  glibcLocales,
  gtk4,
  intltool,
  libadwaita,
  wrapGAppsHook4,
}:

buildDotnetModule rec {
  pname = "Pinta";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "PintaProject";
    repo = "Pinta";
    rev = version;
    hash = "sha256-enCVn52wy42a1cXM2YYCg7RHpkzZoDHc52L6xlxQOo0=";
  };

  nativeBuildInputs = [
    intltool
    wrapGAppsHook4
  ];

  runtimeDeps = [
    gtk4
    libadwaita
  ];

  buildInputs = runtimeDeps;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  # How-to update deps:
  # $ nix-build -A pinta.fetch-deps
  # $ ./result
  # TODO: create update script
  nugetDeps = ./deps.json;

  projectFile = "Pinta";

  # https://github.com/NixOS/nixpkgs/issues/38991
  # bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
  env.LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive";

  # Do the autoreconf/Makefile job manually
  # TODO: use upstream build system
  postBuild = ''
    # Substitute translation placeholders
    intltool-merge -x po/ xdg/pinta.appdata.xml.in xdg/pinta.appdata.xml
    intltool-merge -d po/ xdg/pinta.desktop.in xdg/pinta.desktop

    # Build translations
    dotnet build Pinta \
      --no-restore \
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
    for i in "Pinta.Resources/icons/hicolor/"*; do
      res="$(basename $i)"
      mkdir -p "$out/share/icons/hicolor/$res"
      cp -rv "Pinta.Resources/icons/hicolor/$res/"* "$out/share/icons/hicolor/$res/"
    done

    # Install
    dotnet build installer/linux/install.proj \
      -target:Install \
      -p:ContinuousIntegrationBuild=true \
      -p:Deterministic=true \
      -p:SourceDir="$NIX_BUILD_TOP/source" \
      -p:PublishDir="$NIX_BUILD_TOP/source/publish" \
      -p:InstallPrefix="$out"
  '';

  meta = {
    homepage = "https://www.pinta-project.com/";
    description = "Drawing/editing program modeled after Paint.NET";
    changelog = "https://github.com/PintaProject/Pinta/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thiagokokada ];
    platforms = lib.platforms.linux;
    mainProgram = "pinta";
  };
}
