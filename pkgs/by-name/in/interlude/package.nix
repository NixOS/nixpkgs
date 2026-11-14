{
  lib,
  stdenv,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  copyDesktopItems,
  makeDesktopItem,
  desktopToDarwinBundle,
  nix-update-script,
  imagemagick,
  libbass,
  libbass_fx,
  glfw,
  alsa-lib,
  gtk3,
  glib,
}:

let
  version = "0.7.28.9";
in
buildDotnetModule {
  pname = "interlude";
  inherit version;

  src = fetchFromGitHub {
    owner = "YAVSRG";
    repo = "YAVSRG";
    tag = "interlude-v${version}";
    fetchSubmodules = true;
    hash = "sha256-1MYuP52o5EETc9Fh6tO7h308ftenqOvuvMNkIIZ4tvM=";
  };

  strictDeps = true;

  patches = [
    # Store game data outside the read-only Nix store
    # https://github.com/YAVSRG/YAVSRG/pull/65
    # Skip bundled audio library checks; runtimeDeps provides the libraries
    # https://github.com/YAVSRG/YAVSRG/pull/66
    ./fix-paths.patch
  ];

  postPatch = ''
    # support .NET 10.0
    find . -name '*.fsproj' -exec sed -i \
      's|<TargetFramework>net9[.]0</TargetFramework>|<TargetFramework>net10.0</TargetFramework>|g' {} +
  '';

  nativeBuildInputs = [
    copyDesktopItems
    imagemagick
  ];

  projectFile = "interlude/src/Interlude.fsproj";
  nugetDeps = ./deps.json;
  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  runtimeDeps = [
    # replaced bundled ones in engine/lib/linux-x64
    libbass
    libbass_fx
    # replace the bundled one by OpenTK
    glfw
    # NativeFileDialogSharp
    gtk3
    glib
  ]
  # not sure why this is needed but no audio devices can be found by libbass without this
  ++ lib.optional stdenv.hostPlatform.isLinux alsa-lib
  ++ lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;

  executables = [ "Interlude" ];

  postInstall = ''
    # The icon is pixel art, so it may be converted to a scalable SVG.
    mkdir -p $out/share/icons/hicolor/scalable/apps
    magick site/files/favicon.png -alpha on -sample 20x20! txt:- | \
      sed '1d; s/[():,]/ /g' | \
      awk '{if ($6>0) printf "<rect x=\"%d\" y=\"%d\" width=\"4\" height=\"4\" fill=\"rgb(%d,%d,%d)\" />\n",$1*4,$2*4,$3,$4,$5}' | \
      (echo '<svg width="80" height="80" xmlns="http://www.w3.org/2000/svg" shape-rendering="crispEdges">'; cat; echo '</svg>') \
      > $out/share/icons/hicolor/scalable/apps/interlude.svg
  '';

  preFixup = ''
    # Remove bundled GLFW and use the one from nixpkgs instead.
    rm $out/lib/interlude/libglfw* || true
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Interlude";
      exec = "Interlude %U";
      comment = "A keyboard rhythm game, built for fun";
      icon = "interlude";
      desktopName = "Interlude";
      genericName = "Interlude";
      categories = [
        "Game"
        "Music"
      ];
    })
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=interlude-v(.+)" ];
  };

  meta = {
    description = "Keyboard rhythm game built for fun, part of the YAVSRG project";
    homepage = "https://www.yavsrg.net";
    changelog = "https://www.yavsrg.net/interlude/changelog.html";
    license = with lib.licenses; [
      gpl3Only
      mit
    ];
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = lib.platforms.unix;
    # runtimeDeps doesn't work on darwin: https://github.com/NixOS/nixpkgs/issues/530072#issuecomment-4929467982
    badPlatforms = lib.platforms.darwin;
    mainProgram = "Interlude";
  };
}
