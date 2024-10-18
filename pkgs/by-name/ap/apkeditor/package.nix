{
  lib,
  stdenv,
  fetchFromGitHub,

  jre,
  gradle_6,
  makeWrapper,
}:

let
  gradle = gradle_6;
  REAndroidLibrary =
    args:
    let
      inherit (args) pname version projectName;
      outJar = "share/${projectName}/${projectName}.jar";
      self = stdenv.mkDerivation (
        {
          __darwinAllowLocalNetworking = true;

          buildInputs = [ jre ];
          nativeBuildInputs = [ gradle ];

          gradleFlags = [ "-Dfile.encoding=utf-8" ];
          gradleBuildTask = "jar";
          doCheck = true;

          inherit outJar;
          installPhase = ''
            runHook preInstall
            install -Dm644 build/libs/*.jar $out/${outJar}
            runHook postInstall
          '';
        }
        // args
        // {
          meta.sourceProvenance = with lib.sourceTypes; [
            fromSource
            binaryBytecode # mitm cache
          ];
        }
      );
    in
    self;

  arsclib = REAndroidLibrary {
    pname = "arsclib";
    version = "1.3.5-unstable-2024-10-21"; # 1.3.5 is not new enough for APKEditor
    projectName = "ARSCLib";

    src = fetchFromGitHub {
      owner = "REAndroid";
      repo = "ARSCLib";
      rev = "ed6ccf00e56d7cce13e8648ad46a2678a6093248";
      hash = "sha256-jzd7xkc4O+P9hlGsFGGl2P3pqVvV5+mDyKTRUuGfFSA=";
    };

    mitmCache = gradle.fetchDeps {
      pkg = arsclib;
      data = ./deps-arsclib.json;
    };
  };

  smali = REAndroidLibrary {
    pname = "smali";
    version = "2024-10-15";
    projectName = "smali";

    src = fetchFromGitHub {
      owner = "REAndroid";
      repo = "smali-lib";
      rev = "c781eafb31f526abce9fdf406ce2c925fec20d28";
      hash = "sha256-6tkvikgWMUcKwzsgbfpxlB6NZBAlZtTE34M3qPQw7Y4=";
    };

    mitmCache = gradle.fetchDeps {
      pkg = smali;
      data = ./deps-smali.json;
    };
    gradleBuildTask = "build";

    installPhase = ''
      runHook preInstall
      install -Dm644 smali/build/libs/*-fat.jar $out/${smali.outJar}
      runHook postInstall
    '';
  };

  jcommand = REAndroidLibrary {
    pname = "jcommand";
    version = "2024-09-20";
    projectName = "JCommand";

    src = fetchFromGitHub {
      owner = "REAndroid";
      repo = "JCommand";
      rev = "714b6263c28dabb34adc858951cf4bc60d6c3fed";
      hash = "sha256-6Em+1ddUkZBCYWs88qtfeGnxISZchFrHgDL8fsgZoQg=";
    };

    mitmCache = gradle.fetchDeps {
      pkg = jcommand;
      data = ./deps-jcommand.json;
    };
  };

  apkeditor =
    let
      pname = "apkeditor";
      version = "1.4.1";
      projectName = "APKEditor";
    in
    REAndroidLibrary {
      inherit pname version projectName;

      # When you need to update deps-*.json for the dependencies (e.g. for smali),
      # uncomment the following line and run `nix build apkeditor.smali.mitmCache.updateScript`.

      # inherit arsclib smali jcommand;

      src = fetchFromGitHub {
        owner = "REAndroid";
        repo = "APKEditor";
        rev = "V${version}";
        hash = "sha256-a72j9qGjJXnTFeqLez2rhBSArFVYCX+Xs7NQd8CY5Yk=";
      };

      nativeBuildInputs = [
        gradle
        arsclib
        smali
        jcommand
        makeWrapper
      ];

      mitmCache = gradle.fetchDeps {
        pkg = apkeditor;
        data = ./deps-apkeditor.json;
      };
      gradleBuildTask = "fatJar";

      preConfigure = ''
        ln -sf ${arsclib}/${arsclib.outJar} libs/ARSCLib.jar
        ln -sf ${smali}/${smali.outJar} libs/smali.jar
        ln -sf ${jcommand}/${jcommand.outJar} libs/JCommand.jar
      '';

      postInstall = ''
        mkdir -p $out/bin
        makeWrapper ${lib.getExe jre} $out/bin/APKEditor \
          --add-flags "-jar $out/${apkeditor.outJar}"
      '';

      meta = {
        description = "Powerful android apk resources editor";
        maintainers = with lib.maintainers; [ ulysseszhan ];
        license = lib.licenses.asl20;
        platforms = lib.platforms.all;
        mainProgram = "APKEditor";
      };
    };
in
apkeditor
