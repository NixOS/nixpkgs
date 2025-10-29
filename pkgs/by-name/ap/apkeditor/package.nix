{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  versionCheckHook,

  jre,
  gradle,
  makeWrapper,
}:

let
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
          meta = {
            sourceProvenance = with lib.sourceTypes; [
              fromSource
              binaryBytecode # mitm cache
            ];
          }
          // args.meta;
        }
      );
    in
    self;

  arsclib = callPackage ./arsclib { inherit REAndroidLibrary; };
  smali = callPackage ./smali { inherit REAndroidLibrary; };
  jcommand = callPackage ./jcommand { inherit REAndroidLibrary; };

  apkeditor =
    let
      pname = "apkeditor";
      version = "1.4.5";
      projectName = "APKEditor";
    in
    REAndroidLibrary {
      inherit pname version projectName;

      # When you need to update **/deps.json for the dependencies (e.g. for smali),
      # run `nix build apkeditor.passthru.deps.smali.mitmCache.updateScript`.
      passthru.deps = {
        inherit arsclib smali jcommand;
      };

      src = fetchFromGitHub {
        owner = "REAndroid";
        repo = "APKEditor";
        tag = "V${version}";
        hash = "sha256-yuNMyEnxTjHPSBPWVD8b+f612hWGGayZHKHxtWtxXDg=";
      };

      patches = [
        # Remove this patch after REAndroid/APKEditor#144 is merged
        ./fix-gradle.patch
      ];

      nativeBuildInputs = [
        gradle
        makeWrapper
      ];

      gradleBuildTask = "fatJar";

      # The paths libs/*.jar are hardcoded in build.gradle of APKEditor:
      # https://github.com/REAndroid/APKEditor/blob/V1.4.1/build.gradle#L24-L31
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

      doInstallCheck = true;
      nativeInstallCheckInputs = [ versionCheckHook ];

      passthru.updateScript = ./update.sh;

      meta = {
        description = "Powerful android apk resources editor";
        homepage = "https://github.com/REAndroid/APKEditor";
        changelog = "https://github.com/REAndroid/APKEditor/releases/tag/V${version}";
        maintainers = with lib.maintainers; [ ulysseszhan ];
        license = lib.licenses.asl20;
        platforms = lib.platforms.all;
        mainProgram = "APKEditor";
      };
    };
in
apkeditor
