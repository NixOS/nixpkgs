{
  lib,
  stdenv,
  fetchFromGitHub,
  openjdk,
  openjfx,
  gradle_8,
  fetchpatch2,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
}:
let
  jdk = openjdk.override (
    lib.optionalAttrs stdenv.hostPlatform.isLinux {
      enableJavaFX = true;
      openjfx_jdk = openjfx.override { withWebKit = true; };
    }
  );

  # "Deprecated Gradle features were used in this build, making it incompatible with Gradle 9.0."
  gradle = gradle_8;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "scenic-view";
  version = "11.0.2";

  src = fetchFromGitHub {
    owner = "JonathanGiles";
    repo = "scenic-view";
    rev = finalAttrs.version;
    sha256 = "1idfh9hxqs4fchr6gvhblhvjqk4mpl4rnpi84vn1l3yb700z7dwy";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/JonathanGiles/scenic-view/commit/0f682bba77e9662ce860216987c94e468f5da421.patch?full_index=1";
      hash = "sha256-ISbKexjpGfS8xaRR4GqJ0J+z8fdv8+n4VCO6/SvLGlw=";
      excludes = [
        "*.md"
      ];
    })
  ];

  nativeBuildInputs = [
    gradle
    makeWrapper
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "scenic-view";
      desktopName = "scenic-view";
      exec = "scenic-view";
      comment = "JavaFx application to visualize and modify the scenegraph of running JavaFx applications.";
      mimeTypes = [
        "application/java"
        "application/java-vm"
        "application/java-archive"
      ];
      categories = [ "Development" ];
    })
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  doCheck = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/scenic-view
    cp build/libs/scenicview.jar $out/share/scenic-view/scenic-view.jar
    makeWrapper ${jdk}/bin/java $out/bin/scenic-view --add-flags "-jar $out/share/scenic-view/scenic-view.jar"

    runHook postInstall
  '';

  meta = {
    broken =
      stdenv.hostPlatform.isDarwin || (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    description = "JavaFx application to visualize and modify the scenegraph of running JavaFx applications";
    mainProgram = "scenic-view";
    longDescription = ''
      A JavaFX application designed to make it simple to understand the current state of your application scenegraph
      and to also easily manipulate properties of the scenegraph without having to keep editing your code.
      This lets you find bugs and get things pixel perfect without having to do the compile-check-compile dance.
    '';
    homepage = "https://github.com/JonathanGiles/scenic-view/";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # deps
    ];
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ wirew0rm ];
    platforms = lib.platforms.all;
  };
})
