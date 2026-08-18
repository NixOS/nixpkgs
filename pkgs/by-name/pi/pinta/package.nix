{
  lib,
  stdenv,
  dotnetCorePackages,
  buildDotnetModule,
  fetchFromGitHub,
  glibcLocales,
  gtk4,
  glib,
  libadwaita,
  intltool,
  wrapGAppsHook4,
  nix-update-script,

  # Darwin transitive deps
  graphene,
  gettext,
  pango,
  gdk-pixbuf,
  cairo,
  harfbuzz,
  fribidi,
  fontconfig,
  freetype,
  libthai,
  pcre2,
  libepoxy,
}:

buildDotnetModule rec {
  pname = "Pinta";
  version = "3.1.2";
  src = fetchFromGitHub {
    owner = "PintaProject";
    repo = "Pinta";
    rev = version;
    hash = "sha256-CTASSNMZneU0PQKsDZ/ZMwTkXdJNlVCafaDFqzmh2CM=";
  };

  nativeBuildInputs = [
    intltool
    wrapGAppsHook4
  ];

  runtimeDeps = [
    gtk4
    glib
    libadwaita
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Transitive dylib deps that Pinta's NativeImportResolver dlopen's by bare name.
    # These are not pulled in by wrapGAppsHook4's LD_LIBRARY_PATH on Darwin, so symlink is needed.
    graphene
    gettext
    pango
    gdk-pixbuf
    cairo
    harfbuzz
    fribidi
    fontconfig
    freetype
    libthai
    pcre2
    libepoxy
  ];

  buildInputs = runtimeDeps;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  nugetDeps = ./deps.json;

  projectFile = "Pinta";

  env = lib.optionalAttrs (!stdenv.hostPlatform.isDarwin) {
    LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive";
  };

  dotnetFlags = [ "-p:BuildTranslations=true" ];

  postBuild = ''
    intltool-merge -x po/ xdg/com.github.PintaProject.Pinta.metainfo.xml.in xdg/com.github.PintaProject.Pinta.metainfo.xml
    intltool-merge -d po/ xdg/com.github.PintaProject.Pinta.desktop.in xdg/com.github.PintaProject.Pinta.desktop
  '';

  postFixup = ''
    # Two-step rename needed on macOS: 'Pinta' is the same as 'pinta' on case-insensitive filesystems.
    mv "$out/bin/Pinta" "$out/bin/pinta_tmp"
    mv "$out/bin/pinta_tmp" "$out/bin/pinta"

    # Use icons from the dotnet publish output (already at $out/lib/Pinta/icons/).
    mkdir -p "$out/share/icons"
    cp -r "$out/lib/Pinta/icons/." "$out/share/icons/"
  ''
  + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    dotnet build installer/linux/install.proj \
      -target:Install \
      -p:ContinuousIntegrationBuild=true \
      -p:Deterministic=true \
      -p:SourceDir="$NIX_BUILD_TOP/source" \
      -p:PublishDir="$out/lib/Pinta" \
      -p:InstallPrefix="$out"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Symlink all dylibs from runtimeDeps into the assembly dir.
    # GirCore and Pinta's own NativeImportResolver both search here by bare name.
    for dir in ${lib.concatMapStringsSep " " (d: "${lib.getLib d}/lib") runtimeDeps}; do
      for dylib in "$dir"/*.dylib; do
        [ -e "$dylib" ] || continue
        ln -sf "$dylib" "$out/lib/Pinta/$(basename "$dylib")"
      done
    done

    APP="$out/Applications/Pinta.app/Contents"
    mkdir -p "$APP/MacOS" "$APP/Resources"

    cp "$NIX_BUILD_TOP/source/installer/macos/Info.plist" "$APP/Info.plist"
    cp "$NIX_BUILD_TOP/source/installer/macos/pinta.icns" "$APP/Resources/pinta.icns"

    ln -s "$out/bin/pinta" "$APP/MacOS/pinta"
    ln -s "$out/share" "$APP/Resources/share"
    ln -s "$out/lib"   "$APP/Resources/lib"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://www.pinta-project.com/";
    description = "Drawing/editing program modeled after Paint.NET";
    changelog = "https://github.com/PintaProject/Pinta/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      thiagokokada
      philocalyst
    ];
    platforms = lib.platforms.unix;
    mainProgram = "pinta";
  };
}
