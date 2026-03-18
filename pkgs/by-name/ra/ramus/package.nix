{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle,
  jre,
  makeWrapper,
  libx11,
  libxext,
  libGL,
}:
let
  self = stdenv.mkDerivation (finalAttrs: {
    pname = "ramus";
    version = "2.0.2";

    src = fetchFromGitHub {
      owner = "Vitaliy-Yakovchuk";
      repo = "ramus";
      rev = "v${finalAttrs.version}";
      hash = "sha256-2rbcUqM0YgwPLo8lNFCRJQDlHZQEivB3GRG/iIlwXiQ=";
    };

    nativeBuildInputs = [
      gradle
      makeWrapper
    ];

    mitmCache = gradle.fetchDeps {
      pkg = self;
      data = ./deps.json;
    };

    doCheck = false;
    patchPhase = ''
      runHook prePatch
      sed -i "/plugins {/,/^}/d" build.gradle
      sed -i "/^dependencies {/,/^}/d" build.gradle
      sed -i "/^izpack {/,/^}/d" build.gradle
      sed -i "s|org.dockingframes:docking-frames-common:1.1.2-SNAPSHOT|org.dockingframes:docking-frames-common:1.1.1|g" \
        gui-framework-core/build.gradle
      sed -i "/    maven {/{N;N;/freehep/d}" client/build.gradle
      sed -i "s/sourceCompatibility = 1\.6/sourceCompatibility = 8/" build.gradle
      sed -i "s/targetCompatibility = 1\.6/targetCompatibility = 8/" build.gradle
      runHook postPatch
    '';
    gradleBuildTask = "copyFiles";
    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/ramus
      cp -r dest/full/lib $out/share/ramus/
      cp -r dest/full/bin $out/share/ramus/

      makeWrapper ${jre}/bin/java $out/bin/ramus \
        --add-flags "-cp '$out/share/ramus/lib/ramus/*:$out/share/ramus/lib/thirdparty/*' com.ramussoft.local.Main" \
        --prefix LD_LIBRARY_PATH : "${
          lib.makeLibraryPath [
            libx11
            libxext
            libGL
          ]
        }"

      runHook postInstall
    '';

    meta = {
      description = "Java-based IDEF0 and DFD modelling tool";
      longDescription = ''
        Ramus is a desktop application for creating IDEF0 functional decomposition
        diagrams and Data Flow Diagrams (DFD). It is written in Java/Swing and
        supports saving/loading projects in its own XML-based format.
      '';
      homepage = "https://github.com/Vitaliy-Yakovchuk/ramus";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [ mootfrost ];
      mainProgram = "ramus";
      platforms = lib.platforms.linux;
    };
  });
in
self
