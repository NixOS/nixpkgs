{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  fetchpatch,
  dotnetCorePackages,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
  imagemagick,
  libbass,
  libbass_fx,
  glfw,
  alsa-lib,
}:

let
  version = "0.7.28.1";
in
buildDotnetModule {
  pname = "interlude";
  inherit version;

  src = fetchFromGitHub {
    owner = "YAVSRG";
    repo = "YAVSRG";
    tag = "interlude-v${version}";
    fetchSubmodules = true;
    hash = "sha256-0Qbnywbq4cs/WPhvCou31FFKdqjRhZ4Aww06D1h5Nx4=";
  };

  patches = [
    # Fallback game dir when the executable dir is not writable
    # https://github.com/YAVSRG/YAVSRG/pull/65
    (fetchpatch {
      name = "log-path.patch";
      url = "https://github.com/YAVSRG/YAVSRG/commit/6e56a3d78caf4cbc8e17190fea3adb4d061d5284.patch";
      hash = "sha256-eyvq2GIAZuHYhtAdYLe0csJxHZCrw9soXmRl2eJA7Bg=";
    })

    # Looking for bass and bass_fx in LD_LIBRARY_PATH
    # https://github.com/YAVSRG/YAVSRG/pull/66
    (fetchpatch {
      name = "library-path.patch";
      url = "https://github.com/YAVSRG/YAVSRG/commit/911a8b7f3931823d9fee99f0cb679a3c03298286.patch";
      hash = "sha256-WUbI38EMGvlVl8h7YLJLPsGczhX5PWMLTmy94IRxaBM=";
    })
  ];

  nativeBuildInputs = [
    copyDesktopItems
    imagemagick
  ];

  projectFile = "interlude/src/Interlude.fsproj";
  nugetDeps = ./deps.json;
  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;

  runtimeDeps = [
    # replaced bundled ones in engine/lib/linux-x64
    libbass
    libbass_fx
    # replace the bundled one by OpenTK
    glfw
    # not sure why this is needed but no audio devices can be found by libbass without this
    alsa-lib
  ];

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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Keyboard rhythm game built for fun, part of the YAVSRG project";
    homepage = "https://www.yavsrg.net";
    changelog = "https://www.yavsrg.net/interlude/changelog.html";
    license = with lib.licenses; [
      gpl3Only
      mit
    ];
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = lib.platforms.linux;
    mainProgram = "Interlude";
  };
}
