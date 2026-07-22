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

buildGoModule (finalAttrs: {
  pname = "olivetin";
  version = "3000.15.0";

  src = fetchFromGitHub {
    owner = "OliveTin";
    repo = "OliveTin";
    tag = finalAttrs.version;
    hash = "sha256-AztJqhSJV9hIsnhaYZoIMC8ZE17pUT37nRUdCZ6ZiCA=";
  };

  modRoot = "service";

  vendorHash = "sha256-lZ3KBoM+cDyYPX16wuZT3UQvB/SrRD6W2ic+GznG7hU=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  __darwinAllowLocalNetworking = true;

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

    postFixup = ''
      find $out -type f -name '*.go' -exec \
        sed -i -E 's|//.*protoc-gen-go(-grpc)? +v.*$||' {} +
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-v7aSikl1VSFZdNKnIucs7RdqFWoaVNIH9u27YG9Ei90=";
  };

  webui = buildNpmPackage {
    pname = "olivetin-webui";
    inherit (finalAttrs) version src;

    npmDepsHash = "sha256-fr5RTPNXNd8sD/LphnDsekIbB333LgEHCb/NUEqSBIE=";

    sourceRoot = "${finalAttrs.src.name}/frontend";

    buildPhase = ''
      runHook preBuild

      make build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      cp -r dist $out

      runHook postInstall
    '';
  };

  nativeBuildInputs = [ installShellFiles ];

  preBuild = ''
    ln -s ${finalAttrs.gen} gen
    substituteInPlace internal/config/config.go \
      --replace-fail 'config.WebUIDir = "./webui"' 'config.WebUIDir = "${finalAttrs.webui}"'
  '';

  postInstall = ''
    installManPage ../var/manpage/OliveTin.1.gz
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";
  doInstallCheck = true;

  passthru = {
    tests.olivetin = nixosTests.olivetin.extendNixOS {
      module = {
        services.olivetin.package = finalAttrs.finalPackage;
      };
    };
    releaseSeries = "3k";
    updateScript = ./update-3k.sh;
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
})
