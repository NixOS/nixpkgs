{
  lib,
  fetchFromGitHub,
  buildGoModule,
  stdenvNoCC,
  writableTmpDirAsHomeHook,
  buf,
  protoc-gen-go,
  protoc-gen-go-grpc,
  grpc-gateway,
  buildNpmPackage,
  installShellFiles,
  versionCheckHook,
  nixosTests,
}:

buildGoModule (
  finalAttrs:

  let
    gen = stdenvNoCC.mkDerivation {
      pname = "olivetin-gen";
      inherit (finalAttrs) version src;

      nativeBuildInputs = [
        writableTmpDirAsHomeHook
        buf
        protoc-gen-go
        protoc-gen-go-grpc
        grpc-gateway
      ];

      buildPhase = ''
        runHook preBuild

        pushd proto
        buf generate
        popd

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        cp -r service/gen $out

        runHook postInstall
      '';

      outputHashMode = "recursive";
      outputHash = "sha256-KygZ7NqkfhczYy1YMR824Om4NTq06+KHa/jvmsCty3s=";
    };

    webui = buildNpmPackage {
      pname = "olivetin-webui";
      inherit (finalAttrs) version src;

      npmDepsHash = "sha256-VxIPjpsbxEPP15cu5Wvz0qeDGXTMb2tojdry8YaHMVI=";

      sourceRoot = "${finalAttrs.src.name}/webui.dev";

      buildPhase = ''
        runHook preBuild

        npx parcel build --public-url "."

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        cp -r dist $out
        cp -r *.png $out

        runHook postInstall
      '';
    };
  in

  {
    pname = "olivetin";
    version = "2025.4.22";

    src = fetchFromGitHub {
      owner = "OliveTin";
      repo = "OliveTin";
      tag = finalAttrs.version;
      hash = "sha256-dgoYGtBsyaCTgxCT/y7rU5B9pEvIU/yiLU2/pPm/vJU=";
    };

    modRoot = "service";

    vendorHash = "sha256-yUW4BrC7Oqs+mvvZGp6oxdGQ9fxP5gQNacq6Pz5ZHAQ=";

    ldflags = [
      "-s"
      "-w"
      "-X main.version=${finalAttrs.version}"
    ];

    __darwinAllowLocalNetworking = true;

    nativeBuildInputs = [ installShellFiles ];

    preBuild = ''
      ln -s ${gen} gen
      substituteInPlace internal/config/config.go \
        --replace-fail 'config.WebUIDir = "./webui"' 'config.WebUIDir = "${webui}"'
      substituteInPlace internal/httpservers/webuiServer_test.go \
        --replace-fail '"../webui/"' '"${webui}"'
    '';

    postInstall = ''
      installManPage ../var/manpage/OliveTin.1.gz
    '';

    nativeInstallCheckInputs = [ versionCheckHook ];
    versionCheckProgram = "${placeholder "out"}/bin/OliveTin";
    versionCheckProgramArg = "-version";
    doInstallCheck = true;

    passthru = {
      inherit gen webui;
      tests = { inherit (nixosTests) olivetin; };
      updateScript = ./update.sh;
    };

    meta = {
      description = "Gives safe and simple access to predefined shell commands from a web interface";
      homepage = "https://www.olivetin.app/";
      downloadPage = "https://github.com/OliveTin/OliveTin";
      changelog = "https://github.com/OliveTin/OliveTin/releases/tag/${finalAttrs.version}";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ defelo ];
      mainProgram = "OliveTin";
    };
  }
)
